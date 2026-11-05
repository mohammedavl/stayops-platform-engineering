# Skills → Evidence Map

Keep resume language tied to artifacts and tests. Update evidence only after implementation is committed and verified.

| Skill | Evidence to build | Proof |
|---|---|---|
| Linux | operational scripts and troubleshooting notes | commands and reproducible procedure |
| Bash | health/preflight/cleanup helpers | ShellCheck and controlled test cases |
| Python | platform automation CLI (not an application) | unit tests and sample output |
| Git | reviewable changes, branches, tags | history and rationale |
| YAML | Kubernetes/Helm/CI config | lint/schema validation |
| Containers | Containerfile/runtime notes | build/run/inspect output |
| Kubernetes | namespaces, deployments, services, probes, resources | live local cluster evidence |
| OpenShift | EX280 admin labs and troubleshooting | explicitly OpenShift-specific proof |
| Disconnected operations | mirroring workflow and checksums | separate prior experience from new execution |
| Networking | DNS/ingress/proxy config and diagnosis | config/connectivity tests |
| Storage | PV/PVC lifecycle and trade-offs | lab evidence or design-only label |
| CI/CD | GitHub Actions | successful workflow runs |
| GitOps | Argo CD sync, drift, rollback | sync status and before/after evidence |
| Automation/IaC | Ansible idempotency; Terraform only with use case | repeat-run and plan/apply output |
| Security | RBAC, policies, image/config scanning | scan output and remediation |
| Observability | dashboards, alerts, runbooks | metric query and diagnosis |
| Reliability | incident/recovery exercise | timeline, cause, corrective/preventive actions |

## Claim labels
- **Previously experienced:** earlier labs/jobs; describe accurately.
- **Implemented here:** code/config and test evidence are present.
- **Documented:** procedure/design exists, execution not asserted.
- **Simulated:** local substitute/mock used.
- **Planned:** not delivered.

A tool in a skills list is not proof by itself. Link specific files, workflow runs, and evidence records.