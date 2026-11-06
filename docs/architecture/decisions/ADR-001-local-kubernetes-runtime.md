# ADR-001: Local Kubernetes Runtime for Platform Labs

- **Status:** Accepted
- **Date:** 2026-11-06
- **Decision owners:** StayOps platform engineering (portfolio scenario)

## Context
The project needs a repeatable, low-cost environment to practice Kubernetes workload deployment, service networking, configuration, and operational workflows on the available workstation. The workstation uses Windows 11 with Ubuntu WSL2 and Docker Desktop integration. A three-node kind cluster (`stayops`, one control-plane and two workers) is already installed and validated.

## Decision
Use **kind** as the local Kubernetes runtime for hands-on platform-engineering labs and evidence collection. Keep workloads declarative in repository manifests and apply them with Kubernetes tooling.

## Alternatives considered
- **kind:** selected; already working, lightweight, and suitable for local Kubernetes behavior labs.
- **k3d:** viable alternative, but switching adds no immediate value to the established environment.
- **OpenShift:** not interchangeable with kind; OpenShift-specific capabilities require separate OpenShift validation.
- **Managed cloud Kubernetes:** not selected because the current project prioritizes no-cost local practice.

## Consequences
- Local Kubernetes manifests, Deployments, Services, namespaces, and Kustomize overlays can be practiced and validated here.
- The lab is resource-constrained and is not production, highly available, or a managed platform.
- kind evidence does not prove OpenShift Routes, SCC, Operators, or other OpenShift-specific behavior.
- Cloud-managed integrations and production operations remain design or future validation work unless separately tested.
- Keep claims scoped to observed terminal output and documented test evidence.

## Evidence
- Workstation setup: [Windows WSL2 setup](../workstation/windows-wsl2-setup.md)
- Workload and service lab: [NGINX networking evidence](../lab/nginx-service-networking.md)
- Cluster name: `stayops`; one control-plane and two worker nodes; Kubernetes v1.35.0 (observed).
