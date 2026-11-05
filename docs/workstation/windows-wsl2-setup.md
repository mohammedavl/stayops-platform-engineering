# Windows Workstation Setup (WSL2)

**Status:** Planned / in progress  
**Host:** Windows 11 (PowerShell)  
**Linux environment:** Ubuntu on WSL2  
**Purpose:** Prepare a repeatable workstation for the StayOps local Kubernetes lab.

> Do not mark a component complete until its verification command succeeds. This workstation uses Kubernetes (kind), not OpenShift.

## Host inventory

- CPU: Intel Core i9-13900H (14 cores)
- RAM: 31.75 GiB
- C: drive free space at initial inventory: approximately 301 GiB
- WSL default distribution: Ubuntu
- WSL version: 2

## Phase 1 — Container runtime

Install Docker Desktop for Windows from https://www.docker.com/products/docker-desktop/.

1. Use the WSL 2 backend.
2. Start Docker Desktop and wait for the engine to become ready.
3. Open **Settings → Resources → WSL Integration** and enable Ubuntu.
4. Apply/restart if prompted.

Verify in Ubuntu terminal:

```bash
docker version
docker run --rm hello-world
```

**Acceptance:** client and server are shown by `docker version`; hello-world exits successfully.

## Phase 2 — Linux utilities

In Ubuntu:

```bash
sudo apt update
sudo apt install -y curl wget git ca-certificates gnupg
```

## Phase 3 — Kubernetes CLI and tooling

Install kubectl using the official Kubernetes instructions:
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Install kind using the official instructions:
https://kind.sigs.k8s.io/

Install Helm using:
https://helm.sh/docs/intro/install/

Verify:

```bash
docker --version
kubectl version --client
kind version
helm version
git --version
```

## Phase 4 — Resource guardrails

The host has 32 GiB RAM. Start conservatively:
- Docker Desktop memory budget: approximately 12–16 GiB initially.
- Keep several GiB available to Windows.
- Add monitoring/GitOps components in stages; don't deploy the entire stack at once.
- Check free disk space before pulling large images.

Adjust Docker Desktop resource settings based on observed usage, not theoretical maximums.

## Phase 5 — Create the local cluster (later milestone)

Cluster creation is intentionally deferred until Docker and CLI checks pass. The planned topology is a kind cluster with one control-plane node and two worker nodes, subject to resource testing.

## Evidence checklist

- [ ] Docker Desktop installed and engine running
- [ ] Ubuntu Docker integration enabled
- [ ] `docker run --rm hello-world` succeeds from Ubuntu
- [ ] kubectl installed and version captured
- [ ] kind installed and version captured
- [ ] Helm installed and version captured
- [ ] Git identity/configuration verified
- [ ] Cluster created and nodes reach Ready
- [ ] Screenshots/logs captured with sensitive values redacted

## Accuracy and claims

- This is a local WSL2 + kind Kubernetes environment.
- It is not an OpenShift installation or production environment.
- Record versions and test results when each phase is actually completed.
