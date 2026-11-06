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


## Staging overlay deployment — 2026-11-06

User pulled corrected staging overlay (commit 674e054 includes the namespace manifest) and ran `kubectl apply -k deploy/kubernetes/overlays/staging`. Namespace, Service, and Deployment were created successfully. Rollout completed: Deployment nginx 3/3 available. Service nginx-service is ClusterIP 10.96.251.21:80. Three pods Running/Ready with zero restarts: nginx-68cd94f5d4-2g7m4 (10.244.2.12, stayops-worker), nginx-68cd94f5d4-9n9q5 (10.244.1.6, stayops-worker2), nginx-68cd94f5d4-t7s5l (10.244.2.11, stayops-worker). Service endpoints list all three pod IPs on port 80. The deprecated v1 Endpoints warning is informational (EndpointSlice is preferred in Kubernetes 1.33+); it did not affect rollout. This validates staging resource creation, replica count, scheduling, and endpoint registration; HTTP response validation is the next step.


## Staging Service HTTP validation — 2026-11-06

User ran six curls from a temporary pod in `stayops-staging` against `http://nginx-service`. All six returned the expected StayOps HTML and pod-specific backend identity. Responses alternated between `nginx-68cd94f5d4-2g7m4` (3 responses) and `nginx-68cd94f5d4-9n9q5` (3 responses); the third staging replica `nginx-68cd94f5d4-t7s5l` did not appear in this six-request sample. This proves in-namespace Service DNS/HTTP works and requests reached at least two staging backends. It does not prove even balancing or that every replica receives traffic. Temporary `staging-test` pod was deleted.

### Dev/Staging isolation and overlay result

- Dev overlay: namespace `stayops-dev`, 2 replicas (previously rendered and applied via base; dev overlay render confirms configuration).
- Staging overlay: namespace `stayops-staging`, 3 replicas; deployed and HTTP-tested successfully.
- Separate namespaces and namespace-scoped resources establish lab environment separation; this is not a claim of security-grade tenant isolation.
