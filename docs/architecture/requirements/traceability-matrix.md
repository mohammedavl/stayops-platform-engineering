# StayOps Requirements Traceability Matrix

**Status key:** Verified = supported by recorded lab evidence; Implemented = configuration exists but validation/evidence is incomplete; Planned = not yet implemented.

| Requirement | Architecture / capability | Implementation task | Validation | Evidence | Status |
|---|---|---|---|---|---|
| FR-01 Repeatable workload deployment | Kubernetes + Kustomize | Base Deployment and Service; apply via Kustomize | `kubectl apply -k deploy/kubernetes/overlays/dev`; `kubectl rollout status deployment/nginx -n stayops-dev` | `deploy/kubernetes/base/`; NGINX networking lab | Verified (kind lab) |
| FR-02 Dev and staging configurations | Namespace + Kustomize overlays | Dev (2 replicas) and staging (3 replicas) overlays | `kubectl get deploy,pods,svc -n stayops-dev`; repeat for `stayops-staging` | `deploy/kubernetes/overlays/{dev,staging}/`; NGINX lab | Verified (configuration separation; not security isolation) |
| FR-03 Declarative infrastructure | Kustomize | Base manifests and environment overlays | `kubectl kustomize deploy/kubernetes/overlays/dev`; apply and rollout checks | `deploy/kubernetes/` | Verified (current scope) |
| FR-04 Controlled workload onboarding | Workload onboarding / governance | Published intake/onboarding standard; NGINX compliant example still in progress (resources/probes) | Review checklist; validate NGINX resource/probe rollout and service behavior | `docs/platform/workload-onboarding-standard.md`; upcoming NGINX governance evidence | Partial (standard published; workload controls pending) |
| FR-05 Persistent storage | Storage class + PVC/workload | Evaluate kind storage provisioner; create PVC-backed test workload | PVC Bound; write/read persistence across pod replacement | Future storage lab and manifests | Planned |
| FR-06 Access control and workload security | RBAC, Pod Security, NetworkPolicy | Define least-privilege roles and security controls; validate kind support | `kubectl auth can-i`; inspect admission/security settings; policy connectivity tests where supported | Future security lab | Planned |
| FR-07 CI and GitOps | CI pipeline + GitOps controller | Add manifest validation to CI; evaluate GitOps reconciliation separately | CI run; controller sync/health evidence | Existing CI files (inspect); future GitOps lab | Partial (GitOps planned; CI evidence to verify) |
| FR-08 Monitoring and troubleshooting | Metrics + operational diagnostics | Establish metrics/observability stack and troubleshooting procedures | Check targets/metrics; execute documented fault diagnosis | Future observability lab/runbooks | Planned (basic kubectl diagnostics only today) |
| FR-09 Backup, recovery, failure tests | Recovery procedures + test scenarios | Define backup scope; execute restore and controlled failure tests | Restore data/config and verify service/data integrity | Future resilience lab | Planned |
| FR-10 OpenShift-specific capabilities | OpenShift platform layer | Provision/identify supported OpenShift environment; test Routes, SCC, operators, and platform workflows separately | OpenShift CLI/API checks and feature-specific tests | Future OpenShift lab; architecture docs | Planned (kind is not OpenShift) |
| NFR-01 Reproducibility | Declarative manifests | Keep infrastructure changes versioned and repeatable | Clean checkout + Kustomize build/apply validation | Git repository and Kustomize manifests | Verified for current NGINX lab |
| NFR-02 Evidence-backed claims | Evidence process | Record commands, outcomes, limitations, and links | Cross-check claims against command output and committed docs | Evidence ledger + lab docs | In practice; ongoing |
| NFR-03 Resource constraints | Workstation + Docker/WSL limits | Track CPU/RAM and assess topology before expansion | `nproc`, `free -h`, `docker info`, node status | Workstation assessment in evidence ledger | Verified baseline; ongoing guardrail |
| NFR-04 Explicit security validation | Security testing | Validate controls rather than infer security from namespaces | RBAC/admission/network-policy tests | Future security evidence | Planned |
| NFR-05 Lab/production distinction | Architecture decisions + documentation | Label scope, assumptions, and production gaps | Review ADR/architecture/lab docs | ADR-001; architecture overview | Verified/documented |
| NFR-06 Operational procedures include validation | Runbooks | Write procedures with prerequisites, commands, expected outcomes, rollback | Execute runbook and record results | Future operational runbooks | Planned |

## Interpretation and limitations

- “Verified” applies only to the stated local kind lab scope and recorded evidence; it is not a production certification.
- Dev/staging namespaces and overlays demonstrate configuration separation, not tenant-grade security isolation.
- Kustomize deployment evidence does not establish GitOps reconciliation.
- Basic kubectl troubleshooting does not constitute a full monitoring/observability platform.
- OpenShift-only features must be validated on OpenShift, not inferred from kind.
- Requirements remain open until their acceptance criteria and evidence are completed.

## Next traceability actions

1. Inspect existing CI workflow files and record the exact validation currently performed (FR-07).
2. Define workload onboarding and namespace governance (FR-04).
3. Design storage/PVC test (FR-05).
4. Build security validation plan (FR-06/NFR-04).
5. Prioritize OpenShift topology only after resource and access feasibility review (FR-10).
