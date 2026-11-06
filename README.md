# StayOps — Platform Engineering Portfolio

> A production-minded platform engineering lab built with free tooling and reproducible evidence. Fictional hospitality scenario; platform engineering only, no application feature development.

[![CI](https://github.com/mohammedavl/stayops-platform-engineering/actions/workflows/validate.yml/badge.svg)](https://github.com/mohammedavl/stayops-platform-engineering/actions/workflows/validate.yml)

## Mission
Build a credible, evidence-first platform demonstrating Kubernetes operations, Git-based delivery, GitOps, Linux automation, security, observability, and operational readiness. The core project requires no paid cloud account or high-end server; local runtime choices depend on actual workstation capacity.

## Evidence labels
- **Implemented:** artifact exists and has been tested; evidence is linked.
- **Documented:** procedure/design exists, execution is not asserted.
- **Simulated:** lightweight local substitute is used.
- **Planned:** not delivered yet.

Prior OpenShift, SNO, and disconnected-mirroring experience informs this project but is not automatically claimed as a new deliverable. Local Kubernetes is not OpenShift; OpenShift-only behavior will be labeled separately.

## Milestones
| Stage | Outcome | Status |
|---|---|---|
| M0 | Scope, architecture, constraints | In progress |
| M1 | Repository standards and automated validation | In progress |
| M2 | Local Kubernetes foundation, NGINX workload + ClusterIP service validation | In progress — cluster, 2 replicas, service and HTTP 200 verified |
| M3 | Helm packaging and Argo CD GitOps | Planned |
| M4 | Security and supply-chain checks | Planned |
| M5 | Metrics, dashboards, operational runbooks | Planned |
| M6 | Failure/recovery exercises and portfolio walkthrough | Planned |

See [roadmap](docs/roadmap.md), [architecture](docs/architecture/overview.md), and [skills-to-evidence map](docs/skills-to-evidence.md).

## Repository layout
```text
.
├── docs/          # architecture, roadmap, evidence, runbooks, incidents
├── linux/         # Linux operations and Bash automation
├── containers/    # container build/runtime material
├── kubernetes/    # manifests, policies, storage examples
├── openshift/     # OpenShift-specific labs and EX280 notes
├── automation/    # Ansible / IaC
├── gitops/        # Argo CD desired state
├── ci/            # CI helpers
└── observability/ # metrics, dashboards, alert rules
```

## Quality bar
Every meaningful component explains its purpose, setup/teardown, safe configuration, validation commands and expected results, failure modes, and evidence—or explicitly states that it is design-only/simulated.

**Current truth:** this repository is newly initialized. Planned work is not presented as completed experience.