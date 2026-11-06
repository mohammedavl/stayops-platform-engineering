# StayOps Lab Evidence — Workload & Service Networking

**Status:** Validated from user-provided terminal output  
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

> Kubernetes v1.33+ deprecates the legacy Endpoints API; EndpointSlices are the modern resource to inspect.

## Connectivity test
```bash
kubectl run curl-test --image=curlimages/curl --restart=Never --rm -it --namespace=stayops-dev -- curl -I http://nginx-service
```
**Observed:** HTTP `200 OK`, Server `nginx/1.30.6`; temporary test pod deleted after command.

## Evidence / claim boundary
This confirms workload scheduling, ClusterIP service creation, backend endpoint registration, in-cluster DNS resolution, and HTTP connectivity from a temporary pod. It does not yet demonstrate external ingress, TLS, persistent storage, or production HA.
