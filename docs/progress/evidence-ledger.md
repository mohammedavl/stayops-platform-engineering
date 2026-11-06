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


## Kustomize Dev/Staging environment comparison — 2026-11-06
- Rendered Dev overlay confirms namespace `stayops-dev` and Deployment replica target 2.
- Rendered Staging overlay confirms namespace `stayops-staging` and Deployment replica target 3.
- Live namespace checks: both namespaces Active.
- Live Dev: nginx Deployment 2/2 available; nginx-service ClusterIP 10.96.133.129:80; two pods Running/Ready, zero restarts, spread across worker and worker2.
- Live Staging: nginx Deployment 3/3 available; nginx-service ClusterIP 10.96.251.21:80; three pods Running/Ready, zero restarts, spread across worker and worker2.
- Staging Service HTTP smoke test (six requests) returned expected StayOps HTML; observed two of three backends in sample. See NGINX evidence page for detail.
- Verified separate namespace/resource configuration and successful staging deployment. Dev overlay rendering is verified; next step is applying Dev overlay explicitly and checking `kubectl diff -k` for both environments (diff exit code 0 means no changes; 1 means differences).


## Dev overlay explicit apply — 2026-11-06
- Applied `kubectl apply -k deploy/kubernetes/overlays/dev`: Service and Deployment unchanged.
- Rollout status successfully rolled out.
- Dev and Staging `kubectl diff -k` emitted no text; exit codes not captured, so no visible diff recorded without asserting exit code 0.


## Architecture baseline and ADR-001 — 2026-11-06
- Accepted ADR-001: use kind as the local Kubernetes runtime for platform labs; alternatives considered: k3d, OpenShift, managed cloud.
- Rationale: existing validated three-node kind cluster, lightweight/no-cost local practice; avoid switching runtimes without immediate benefit.
- Explicit boundaries: kind evidence does not validate OpenShift Routes, SCC, Operators, production HA, or managed-cloud behavior.
- Architecture overview now separates the implemented local flow (GitHub manifests → Kustomize overlays → kind stayops → Dev/Staging namespaces) from future target capabilities.
- GitHub ADR: [ADR-001-local-kubernetes-runtime.md](../architecture/decisions/ADR-001-local-kubernetes-runtime.md) (commit `cd23856d2be9c8d527173fc3fce38e2adb727489`).
- Architecture overview update: commit `3da2add371ffcd977abe8af79250c4e3c94881be`.
- User synchronized local checkout with successful fast-forward `674e054..3da2add`; ADR file present and `git status --short` showed no changes.
- Next architecture activity: formalize platform requirements, constraints, and acceptance criteria before choosing any OpenShift/cloud topology or provisioning approach.


## Workstation resource assessment — 2026-11-06
- Ubuntu WSL reported 20 logical CPUs; CPU model Intel 13th Gen Core i9-13900H.
- WSL `free -h`: 15 GiB RAM total, ~13 GiB available at measurement; 4 GiB swap configured and unused.
- WSL root filesystem `df -h /`: 1007 GiB size, 954 GiB available at measurement. This is WSL filesystem capacity, not direct Windows C: free-space evidence.
- Docker `docker info`: 20 CPUs, 16,633,741,312 bytes memory (~15.5 GiB), overlayfs.
- kind cluster `stayops`: control-plane and both workers Ready, Kubernetes v1.35.0.
- Git working tree clean.
- Constraint: use Docker/WSL effective resource view for lab sizing; host physical RAM (~31.75 GiB previously observed) is not equivalent to currently allocated/visible WSL memory.
- Recommendation: retain kind as validated baseline; assess OpenShift topology and resource budgets separately before installation.


## Platform requirements baseline — 2026-11-07
- Added `docs/architecture/requirements/platform-requirements.md` defining 10 functional requirements, 6 non-functional requirements, current environment constraints, acceptance criteria, and explicit pending status for detailed topology/implementation decisions.
- Local commit `b295e27` (`docs: define platform requirements baseline`) pushed successfully to `main`; push advanced remote from `6fd5978` to `4a9146b`.
- Verified local branch `main` tracks `origin/main` at `4a9146b`; `git status -sb` showed clean synchronization (`## main...origin/main`). A second push reported `Everything up-to-date`.
- SSH authentication verified: `ssh -T git@github.com` returned `Hi mohammedavl! You've successfully authenticated, but GitHub does not provide shell access.`
- Requirements baseline is documentation evidence; it does not mean all requirements are implemented or accepted by tests.


## CI pipeline audit and Kustomize validation — 2026-11-07
- Audited `.github/workflows/validate.yml`: triggers on push to main, pull_request, and workflow_dispatch; read-only contents permission; Python 3.12 + yamllint (relaxed config, line length disabled).
- Added a separate `kustomize` job using kubectl v1.35.0 to build base, dev, and staging manifests with `kubectl kustomize`. This is offline manifest rendering/validation, not a cluster deployment or health test.
- Workflow update commit: `95a4217ce24c52fe42dd5de832f2e9e009af3ef4`.
- CI run outcome pending; workflow must execute on GitHub after synchronization/push. Local rendering should be checked too.
- Remaining CI gaps: Kubernetes schema/policy validation, workload tests, and deployment verification.


## CI execution status — 2026-11-07
- Local `kubectl kustomize` renders succeeded for base (46 lines), dev (46), staging (51); each command returned exit code 0.
- GitHub Actions runs for commits `95a4217` and `7985a7e` report conclusion `failure`.
- GitHub Actions run/job API returned zero jobs for these runs; root cause is not established from available run metadata. Do not claim a green CI result or infer a failing step.
- Run links: https://github.com/mohammedavl/stayops-platform-engineering/actions/runs/42279735125 and https://github.com/mohammedavl/stayops-platform-engineering/actions/runs/42279760223
- CI acceptance remains open pending investigation of Actions UI/run details.
