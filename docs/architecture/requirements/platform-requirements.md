# StayOps Platform Requirements

## Purpose
Define the platform capabilities and validation criteria for the
StayOps enterprise platform engineering portfolio.

## Functional Requirements
- FR-01: Support repeatable Kubernetes workload deployment.
- FR-02: Support isolated development and staging configurations.
- FR-03: Support declarative infrastructure configuration.
- FR-04: Support controlled workload onboarding.
- FR-05: Support persistent storage workloads.
- FR-06: Support access control and workload security policies.
- FR-07: Support CI validation and GitOps deployment workflows.
- FR-08: Support platform monitoring and operational troubleshooting.
- FR-09: Support backup, recovery, and failure testing.
- FR-10: Document OpenShift-specific platform capabilities separately.

## Non-Functional Requirements
- NFR-01: Infrastructure changes must be reproducible.
- NFR-02: Technical claims must be backed by evidence.
- NFR-03: Lab resource consumption must respect workstation limits.
- NFR-04: Security controls must be explicitly validated.
- NFR-05: Platform documentation must distinguish lab and production.
- NFR-06: Operational procedures must include validation steps.

## Current Constraints
- Windows 11 host with Ubuntu WSL2.
- Docker Desktop WSL2 integration.
- Docker-visible resources: 20 CPUs and approximately 15.5 GiB RAM.
- Existing kind cluster: one control-plane and two workers.
- Local kind is not an OpenShift or production environment.

## Acceptance Criteria
- Requirements map to implementation tasks and evidence.
- Platform topology decisions reference resource constraints.
- Each implemented capability has a reproducible validation.
- OpenShift-specific behavior is tested on OpenShift.
- Unimplemented requirements remain explicitly tracked.

## Status
Initial requirements baseline; detailed topology and implementation
decisions remain pending.
