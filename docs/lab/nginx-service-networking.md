# StayOps Lab Evidence — Workload & Service Networking

**Status:** Validated from user-provided terminal output and screenshot  
**Environment:** Local kind Kubernetes cluster (not OpenShift / not production)  
**Namespace:** `stayops-dev`

## Cluster foundation
- kind cluster: `stayops`
- Topology: 1 control-plane + 2 workers
- All nodes Ready; core system components running (previous validation)

## Workload deployment
Initially deployed NGINX with 2 replicas. Both pods Running/Ready (1/1), zero restarts, scheduled across `stayops-worker` and `stayops-worker2`.

## ClusterIP service
Service `nginx-service`: ClusterIP `10.96.133.129`, TCP/80, selector `app=nginx`. EndpointSlice initially showed two Ready IPv4 endpoints. In-cluster curl returned HTTP 200.

## EndpointSlice validation — screenshot captured 2026-11-06
EndpointSlice `nginx-service-2sk27`, IPv4, TCP/80. Both endpoints Ready:
- `10.244.1.2` → pod `nginx-68964fc4cb-dxgnj`, node `stayops-worker2`
- `10.244.2.2` → pod `nginx-68964fc4cb-z5rs2`, node `stayops-worker`

## Per-replica access logs
Per-pod logs showed successful GET/HEAD HTTP 200 requests on both replicas.

## Unique backend identity and Service routing — 2026-11-06
A ConfigMap template mount experiment returned the stock NGINX welcome page. Corrected with a Deployment startup command generating a pod-specific HTML page using `$HOSTNAME`.

Eight requests through `http://nginx-service` returned pod identities:
- `nginx-75764d87f7-sfsvj`: 5 responses
- `nginx-75764d87f7-s9h9c`: 3 responses
Temporary `backend-test` pod deleted. This proves requests reached both Service backends in this sample; it is not a guarantee of equal distribution or a performance test.

## Declarative configuration with Kustomize — 2026-11-06
Version-controlled manifests added:
- `deploy/kubernetes/base/deployment.yaml`
- `deploy/kubernetes/base/service.yaml`
- `deploy/kubernetes/base/kustomization.yaml`

User cloned repository in Ubuntu WSL, ran `git pull` (already up to date), and applied:
```bash
kubectl apply -k deploy/kubernetes/base
```
Output: `service/nginx-service configured`, `deployment.apps/nginx configured`. Kubernetes warned that pre-existing imperative resources lacked the last-applied annotation; it automatically patched the annotation (expected adoption behavior, not an error).

Validation:
- `kubectl rollout status deployment/nginx -n stayops-dev`: successful rollout
- Deployment: 2/2 ready, 2 available
- Service: ClusterIP `10.96.133.129`, port 80
- Pods: `nginx-5d86cd4dcb-fbzd7` (10.244.1.5, `stayops-worker2`) and `nginx-5d86cd4dcb-q59ff` (10.244.2.9, `stayops-worker`), both 1/1 Running, zero restarts
- Endpoints: `10.244.1.5:80`, `10.244.2.9:80`

## Evidence / claim boundary
Validated multi-node scheduling, ClusterIP service, ready endpoints, in-cluster HTTP, requests reaching both replica backends, and applying version-controlled Kustomize manifests with successful rollout. No external ingress, TLS, persistence, production HA, or formal performance guarantee demonstrated.
