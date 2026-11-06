# StayOps Lab Evidence — Workload & Service Networking

**Status:** Validated from user-provided terminal output and screenshot  
**Environment:** Local kind Kubernetes cluster (not OpenShift / not production)  
**Namespace:** `stayops-dev`

## Cluster foundation
- kind cluster: `stayops`
- Topology: 1 control-plane + 2 workers
- All nodes Ready; core system components running (previous validation)

## Workload deployment
```bash
kubectl create namespace stayops-dev
kubectl create deployment nginx --image=nginx:stable --replicas=2 -n stayops-dev
kubectl rollout status deployment/nginx -n stayops-dev
kubectl get pods -n stayops-dev -o wide
```
Initially both NGINX pods were Running/Ready (1/1), zero restarts, scheduled across `stayops-worker` and `stayops-worker2`.

## ClusterIP service
```bash
kubectl expose deployment nginx --name nginx-service --port 80 --target-port 80 -n stayops-dev
kubectl get svc -n stayops-dev
kubectl describe svc nginx-service -n stayops-dev
kubectl get endpoints nginx-service -n stayops-dev
```
Observed ClusterIP `10.96.133.129`, TCP port 80, selector `app=nginx`, backend endpoints `10.244.1.2:80` and `10.244.2.2:80`.

## EndpointSlice validation — screenshot captured 2026-11-06
Commands:
```bash
kubectl get endpointslices -n stayops-dev -l kubernetes.io/service-name=nginx-service
kubectl describe endpointslice -n stayops-dev -l kubernetes.io/service-name=nginx-service
```
Observed EndpointSlice `nginx-service-2sk27`, IPv4, TCP/80. Both endpoints Ready:
- `10.244.1.2` → pod `nginx-68964fc4cb-dxgnj`, node `stayops-worker2`
- `10.244.2.2` → pod `nginx-68964fc4cb-z5rs2`, node `stayops-worker`

## Per-replica access logs
Per-pod `kubectl logs` showed successful GET/HEAD HTTP 200 requests on both replicas. See Notion evidence for captured command outputs.

## Unique backend identity and Service routing — 2026-11-06
A ConfigMap template was created, then a Deployment command override generated a pod-specific index page using `$HOSTNAME` at container startup. The initial template mount experiment returned the stock NGINX page; corrected with the startup command patch.

Deployment patch:
```bash
kubectl patch deployment nginx -n stayops-dev --type=strategic \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","command":["/bin/sh","-c"],"args":["printf \\"<html><body><h1>StayOps Kubernetes Lab</h1><p>Served by backend: %s</p></body></html>\\\\n\\" \\"$HOSTNAME\\" > /usr/share/nginx/html/index.html && exec nginx -g \\"daemon off;\\""]}]}}}}'
kubectl rollout status deployment/nginx -n stayops-dev
kubectl get pods -n stayops-dev -o wide
```
Observed new pods:
- `nginx-75764d87f7-s9h9c` — 10.244.2.7 on `stayops-worker`
- `nginx-75764d87f7-sfsvj` — 10.244.1.4 on `stayops-worker2`
Both Running/Ready, zero restarts; rollout successful.

Test command:
```bash
kubectl run backend-test --image=curlimages/curl --restart=Never --rm -it -n stayops-dev -- sh -c 'for i in 1 2 3 4 5 6 7 8; do curl -s http://nginx-service; echo; done'
```
Observed eight successful HTML responses through `http://nginx-service`, each displaying the answering pod hostname:
- `nginx-75764d87f7-sfsvj`: 5 responses
- `nginx-75764d87f7-s9h9c`: 3 responses
Temporary `backend-test` pod deleted after completion.

**Conclusion:** Direct, observable evidence that the ClusterIP Service routed requests to both NGINX replica backends. This small sample is not a guarantee of equal distribution or a formal performance test.

## Connectivity test
Earlier curl test returned HTTP `200 OK`, Server `nginx/1.30.6`.

## Evidence / claim boundary
This confirms workload scheduling across workers, ClusterIP Service creation, EndpointSlice readiness, in-cluster DNS, HTTP connectivity, per-pod access logs, and Service requests reaching both replicas. It does not demonstrate external ingress, TLS, persistent storage, production HA, or quantitative load/performance guarantees.
