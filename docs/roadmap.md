# Delivery Roadmap

Milestones are complete only when acceptance criteria and evidence are committed.

## M0 — Scope and architecture
- [x] Define StayOps scenario and platform-only scope
- [x] Establish free/no-paid-cloud design constraint
- [x] Define evidence labels
- [ ] Select local runtime after measuring CPU, RAM, disk
- [ ] Record architecture decisions

**Exit:** architecture, constraints, and acceptance criteria reviewed.

## M1 — Repository engineering
- [x] Initial project documentation
- [ ] CI validates YAML and conventions
- [ ] Add repository change checks

**Exit:** automated syntax validation passes.

## M2 — Kubernetes baseline
- [ ] Select kind or k3d based on local capacity
- [ ] Deploy a representative stateless workload (no application coding)
- [ ] Configure namespace, requests/limits, probes, service
- [ ] Document inspect, rollback, teardown
- [ ] Capture actual command output

**Exit:** workload reproducibly deployed and healthy locally.

## M3 — Packaging and GitOps
- [ ] Package with Helm
- [ ] Add Argo CD desired-state reconciliation
- [ ] Demonstrate drift detection and reconciliation
- [ ] Document promotion and rollback

## M4 — Security
- [ ] Least-privilege RBAC
- [ ] NetworkPolicy and tested boundaries (runtime support noted)
- [ ] CI image/config scanning
- [ ] Secret handling; no credentials committed
- [ ] Findings and remediation documented

## M5 — Observability and operations
- [ ] Metrics and dashboard
- [ ] Actionable alert rules
- [ ] Operator runbooks and troubleshooting
- [ ] Recovery exercise where meaningful

## M6 — Reliability and portfolio review
- [ ] Failure exercise
- [ ] Incident report: impact, timeline, cause, fix, prevention
- [ ] Final architecture/demo walkthrough
- [ ] Resume bullets linked to evidence

## Work log
For each session record objective, changes, commands/tests, outcome, evidence, and next action. Never claim work unsupported by artifacts.