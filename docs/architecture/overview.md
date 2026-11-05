# StayOps Platform — Architecture Baseline

**Status:** initial design; components are not deployed yet.

## Scenario
StayOps is a fictional hospitality organization. The platform team provides a repeatable deployment and operations path for a representative service. Application development is out of scope; use an existing/demo container image.

## Target flow
```mermaid
flowchart TB
  Dev[Engineer] --> Git[GitHub repository]
  Git --> CI[CI: lint and validate]
  Git --> CD[GitOps desired state]
  CD --> K8s[Local Kubernetes lab]
  K8s --> Workload[Namespace and workload]
  K8s --> Obs[Metrics and dashboards]
  CI --> Scan[Security/config checks]
```
This is a target flow, not a claim that all components exist.

## Resource and cost model
- No AWS or paid cloud subscription required.
- GitHub public repository and free CI are the starting point.
- Select local runtime only after checking host RAM, CPU, and disk.
- Keep cluster footprint small; add GitOps and observability incrementally.
- If a component cannot run locally, document/design it or validate config statically—do not claim runtime proof.

## Candidate choices
| Concern | Candidate | Decision note |
|---|---|---|
| Local cluster | kind or k3d | Choose after resource check |
| Packaging | Helm | Reusable workload configuration |
| GitOps | Argo CD | Sync and drift demonstration |
| CI | GitHub Actions | Free repository checks |
| Automation | Ansible | Idempotent host configuration |
| IaC | Terraform | Only if a valid local use case exists |
| Security | RBAC, NetworkPolicy, Trivy | Test behavior and limitations |
| Observability | Prometheus/Grafana or lighter tools | After workload baseline |

## Trust and safety
- Never commit kubeconfig, tokens, private keys, passwords, or unredacted secrets.
- Use least privilege and namespace separation.
- Pin dependency/action versions where practical.
- CI checks do not imply production certification.
- Local Kubernetes differs from OpenShift: SCC, Routes, Operators, and platform APIs need separate OpenShift evidence.

## Architecture decisions
Record context, options, decision, and consequences in `docs/architecture/decisions/`. First decisions: runtime, workload image, GitOps footprint, observability footprint.