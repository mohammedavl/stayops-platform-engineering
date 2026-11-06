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
**Observed:** rollout successful; both NGINX pods Running/Ready (1/1), zero restarts, scheduled across `stayops-worker` and `stayops-worker2`.

## ClusterIP service
```bash
kubectl expose deployment nginx --name nginx-service --port 80 --target-port 80 -n stayops-dev
kubectl get svc -n stayops-dev
kubectl describe svc nginx-service -n stayops-dev
kubectl get endpoints nginx-service -n stayops-dev
```
**Observed:** ClusterIP `10.96.133.129`, TCP port 80, selector `app=nginx`, two backend endpoints `10.244.1.2:80` and `10.244.2.2:80`.

## EndpointSlice validation — screenshot captured 2026-11-06
```bash
kubectl get endpointslices -n stayops-dev -l kubernetes.io/service-name=nginx-service
kubectl describe endpointslice -n stayops-dev -l kubernetes.io/service-name=nginx-service
```
Observed EndpointSlice `nginx-service-2sk27`, IPv4, TCP/80. Both endpoints Ready:
- `10.244.1.2` → pod `nginx-68964fc4cb-dxgnj`, node `stayops-worker2`
- `10.244.2.2` → pod `nginx-68964fc4cb-z5rs2`, node `stayops-worker`
Service label and pod target references present.

## NGINX access-log evidence — 2026-11-06
Command:
```bash
kubectl logs -n stayops-dev -l app=nginx --tail=5
```
User-provided output included:
- `GET /` requests with HTTP/1.1 status `200`, response size 896 bytes, user agent `Wget`.
- `HEAD /` request with status `200`, response size 0, user agent `curl/8.23.0`.
- Client address shown as `10.244.2.4`.
- NGINX worker process startup notices.
This demonstrates successful HTTP requests recorded in NGINX logs. Because the selector-based command aggregates replica logs and output did not label the source pod for each line, it is not yet proof of request distribution between replicas.

## Connectivity test
```bash
kubectl run curl-test --image=curlimages/curl --restart=Never --rm -it --namespace=stayops-dev -- curl -I http://nginx-service
```
Observed HTTP `200 OK`, Server `nginx/1.30.6`; temporary test pod deleted after command.

## Evidence / claim boundary
This confirms workload scheduling, ClusterIP service creation, EndpointSlice backend registration/readiness, in-cluster DNS resolution, and HTTP connectivity from a temporary pod, with access-log confirmation. It does not yet demonstrate per-backend load-balancing distribution, external ingress, TLS, persistent storage, or production HA.
