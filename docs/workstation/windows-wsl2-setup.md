# Windows Workstation Setup (WSL2)

**Status:** Complete for local Kubernetes foundation; ongoing as the lab evolves  
**Host:** Windows 11 (Intel x64 / AMD64-compatible)  
**Linux environment:** Ubuntu on WSL2  
**Purpose:** Reproducible workstation for StayOps local Kubernetes labs.

> This workstation uses Kubernetes (kind), not OpenShift.

## Host inventory

- CPU: Intel Core i9-13900H (14 cores; AMD64/x86_64 architecture)
- RAM: 31.75 GiB
- C: drive free space at initial inventory: approximately 301 GiB
- WSL default distribution: Ubuntu, WSL 2

## Container runtime — verified

- Docker Desktop 4.98.0
- Docker Engine / CLI: 29.9.2
- WSL2 backend enabled; Ubuntu integration enabled
- Docker CLI works from Ubuntu WSL terminal.

## Linux and Kubernetes tooling — verified in Ubuntu

| Tool | Version / evidence |
|---|---|
| kubectl | v1.37.2 (Kustomize v5.8.1) |
| kind | v0.31.0 |
| Helm | v3.22.1 |
| Git | Installed |

Use Ubuntu terminal for Docker, kubectl, kind, and Helm commands. The kubeconfig/context for this lab is in WSL; running kubectl from Windows PowerShell without configuring its kubeconfig can target localhost:8080.

## Local cluster — verified

- kind cluster: `stayops`
- Topology: 1 control-plane + 2 workers
- Kubernetes: v1.35.0
- All nodes Ready:
  - `stayops-control-plane` — 172.18.0.4
  - `stayops-worker` — 172.18.0.3
  - `stayops-worker2` — 172.18.0.2
- kube-system: CoreDNS 2/2, kube-proxy 3/3, local-path-provisioner Running
- API endpoint: https://127.0.0.1:45881

## Workload and networking validation

- Namespace: `stayops-dev`
- Deployment: `nginx`, 2/2 replicas Ready, zero restarts
- Pods scheduled across both workers:
  - `nginx-68964fc4cb-dxgnj` — 10.244.1.2 on `stayops-worker2`
  - `nginx-68964fc4cb-z5rs2` — 10.244.2.2 on `stayops-worker`
- Service: `nginx-service`, ClusterIP `10.96.133.129`, TCP/80
- Service endpoints: 10.244.1.2:80 and 10.244.2.2:80
- In-cluster curl test returned HTTP/1.1 200 OK (NGINX 1.30.6); temporary test pod removed.

## Resource guardrails

The host has approximately 32 GiB RAM. Begin with Docker Desktop allocating approximately 12–16 GiB; retain sufficient memory for Windows. Add GitOps/monitoring components incrementally and check disk space before large image pulls.

## Evidence checklist

- [x] Docker Desktop engine and Ubuntu WSL integration verified
- [x] Docker CLI/Engine version captured
- [x] kubectl, kind, Helm versions captured
- [x] Git installed
- [x] kind cluster created; all nodes Ready
- [x] NGINX workload and Service networking validated
- [x] Evidence documented in `docs/lab/nginx-service-networking.md` and progress ledger
- [ ] Capture/attach optional screenshots of Docker Desktop and terminal outputs (redact sensitive values)

## Accuracy and claims

This is a local WSL2 + kind Kubernetes environment. It is not an OpenShift installation or production environment. Versions and outputs above reflect the observed lab checkpoint; re-verify after upgrades.
