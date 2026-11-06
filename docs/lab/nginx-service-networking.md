# StayOps Lab Evidence — Workload & Service Networking

**Status:** Validated from user-provided terminal output and screenshot  
**Environment:** Local kind Kubernetes cluster (not OpenShift / not production)  
**Namespace:** `stayops-dev`

## Cluster foundation
- kind cluster: `stayops`, 1 control-plane + 2 workers
- Nodes Ready; core system components running (previous validation)

## Workload and ClusterIP
NGINX Deployment has 2 replicas. Service `nginx-service`: ClusterIP `10.96.133.129`, TCP/80, selector `app=nginx`. Initially EndpointSlice showed two Ready IPv4 endpoints; in-cluster curl returned HTTP 200.

## EndpointSlice validation — 2026-11-06
EndpointSlice `nginx-service-2sk27`, IPv4, TCP/80. Ready endpoints:
- `10.244.1.2` → `nginx-68964fc4cb-dxgnj`, `stayops-worker2`
- `10.244.2.2` → `nginx-68964fc4cb-z5rs2`, `stayops-worker`

## Backend identity / Service routing — 2026-11-06
An initial ConfigMap template mount attempt showed the stock NGINX welcome page; corrected by a Deployment startup command generating pod-specific HTML using `$HOSTNAME`.
Eight requests through the Service reached both backends:
- `nginx-75764d87f7-sfsvj`: 5 responses
- `nginx-75764d87f7-s9h9c`: 3 responses
Temporary test pod removed. This is a sample, not equal-distribution/performance proof.

## Declarative Kustomize deployment — 2026-11-06
Repository manifests:
- `deploy/kubernetes/base/deployment.yaml`
- `deploy/kubernetes/base/service.yaml`
- `deploy/kubernetes/base/kustomization.yaml`

User cloned repository and ran `kubectl apply -k deploy/kubernetes/base`. Both resources configured; rollout succeeded. Initial missing last-applied annotation warnings were expected during adoption and automatically patched.

Validated state:
- Deployment `nginx`: 2/2 ready, 2 available
- Service: ClusterIP `10.96.133.129`, TCP/80
- Pods: `nginx-5d86cd4dcb-fbzd7` (10.244.1.5, worker2) and `nginx-5d86cd4dcb-q59ff` (10.244.2.9, worker), both Running/Ready, zero restarts
- Endpoints: `10.244.1.5:80`, `10.244.2.9:80`

### Post-apply HTTP verification
After Kustomize apply, user ran four curls through `nginx-service`. All four returned StayOps HTML with backend `nginx-5d86cd4dcb-fbzd7`. Temporary `backend-test` pod deleted. Confirms Service HTTP functionality and content survived declarative apply; this four-request sample hit one backend only.

## Evidence / claim boundary
Demonstrated multi-node scheduling, ClusterIP and ready endpoints, in-cluster HTTP, sampled requests reaching both replicas, and successful Kustomize apply/rollout plus post-apply traffic. Does not demonstrate external ingress, TLS, persistence, production HA, or quantitative performance.
