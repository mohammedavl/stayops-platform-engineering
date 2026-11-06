# StayOps — Progress & Evidence Ledger (as of 2026-11-06)

This ledger captures the project work and validations reported in the conversation. It distinguishes verified local execution from repository/documentation work and future tasks.

## Project scope and working agreement
- StayOps is a fictional hospitality business scenario used for a real platform-engineering portfolio.
- Platform/infrastructure only; no hospitality application development.
- Local kind Kubernetes is not OpenShift and is not production/HA.
- Evidence-first: only mark execution verified when terminal output or other evidence supports it.
- GitHub and Notion are project records; update them at every meaningful milestone.

## Workstation and tools
- Host: Windows laptop; Intel Core i9-13900H (14 cores), 31.75 GiB RAM; initial C: free space ~301 GiB.
- Ubuntu installed on WSL2 (WSL version 2).
- Docker Desktop installed; WSL2 backend enabled; Ubuntu integration enabled.
- Docker CLI connects to Docker Desktop engine from Ubuntu; Docker client/server version reported 29.9.2; Docker Desktop 4.98.0.
- kubectl installed in Ubuntu: v1.37.2 (Kustomize v5.8.1).
- kind installed: v0.31.0.
- Helm installed: v3.22.1.
- Git installed in Ubuntu.
- Important workflow: run kubectl/kind/Helm/Git lab commands inside Ubuntu WSL; Windows PowerShell does not share this WSL kubeconfig/context by default.

## Local cluster
- kind cluster: `stayops`
- 1 control-plane + 2 worker nodes.
- Kubernetes version: v1.35.0.
- Nodes observed Ready:
  - `stayops-control-plane` — 172.18.0.4
  - `stayops-worker` — 172.18.0.3
  - `stayops-worker2` — 172.18.0.2
- kube-system observed healthy: CoreDNS 2/2, kube-proxy 3/3, local-path-provisioner Running; control plane reachable at https://127.0.0.1:45881.
- Earlier Windows PowerShell kubectl attempted localhost:8080; corrected by using Ubuntu WSL terminal.

## Workload and service networking — verified 2026-11-06
- Namespace: `stayops-dev`.
- Deployment: `nginx`, image `nginx:stable`, 2 replicas.
- Rollout successful; both pods Ready 1/1, Running, zero restarts.
- Pod placement spans `stayops-worker` and `stayops-worker2`.
- Service: `nginx-service`, ClusterIP `10.96.133.129`, TCP 80, selector `app=nginx`.
- Service backend endpoints: `10.244.1.2:80` and `10.244.2.2:80`.
- Temporary curl pod ran `curl -I http://nginx-service`; observed HTTP 200 OK, Server nginx/1.30.6; test pod removed.
- Validated deployment scheduling, ClusterIP, endpoint registration, in-cluster DNS/service connectivity, HTTP response.
- EndpointSlices are preferred over deprecated core/v1 Endpoints for newer Kubernetes.

## Social/portfolio communication
- User published a concise LinkedIn milestone post (user confirmed posted); no claim that assistant posted it.
- Social post is communication only, not a technical deliverable.

## GitHub artifacts already present
- README, roadmap, architecture overview, skills-to-evidence map, contributing guide, .gitignore, CI validation workflow.
- Workstation setup doc: `docs/workstation/windows-wsl2-setup.md`.
- Lab evidence: `docs/lab/nginx-service-networking.md` (commit c02035f).

## Notion records
- Master project: StayOps — Enterprise Platform Engineering | Master Project.
- Windows WSL2 Workstation Setup & Validation child page.
- StayOps — NGINX Workload & Service Networking Evidence page (created 2026-11-06).

## Not yet completed / do not claim
- EndpointSlice inspection / repeated-request test not yet reported executed.
- External access/Ingress/Route, TLS, persistent storage, Helm packaging, GitOps/Argo CD, RBAC/policies, observability, security/supply-chain, backup/recovery/failure testing not yet implemented in this local lab.
- No OpenShift deployment in this kind cluster.
