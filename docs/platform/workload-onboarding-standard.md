# StayOps Workload Onboarding Standard

## 1. Purpose
Define a repeatable process for onboarding workloads onto the StayOps
platform. Workloads must be documented, validated, and operated within
approved platform constraints.

## 2. Scope
This standard applies to Kubernetes workloads in StayOps development
and staging environments. It is a platform engineering standard, not
an application development guide.

The local kind environment is a learning and validation environment.
It does not establish production readiness or OpenShift compliance.

## 3. Workload Intake

Before deployment, record:

- Workload name and purpose.
- Technical owner and operational contact.
- Target environment and namespace.
- Container image and version/tag.
- Required ports and service exposure.
- CPU and memory requirements.
- Storage requirements, if any.
- Health-check requirements.
- Security and access requirements.
- Dependencies and operational risks.
- Rollback approach and success criteria.

Incomplete intake must be resolved before workload onboarding proceeds.

## 4. Environment and Namespace

- Select an approved environment: development or staging.
- Deploy into the designated namespace.
- Do not deploy workloads into the default namespace.
- Namespace separation is organizational and configuration separation;
  it is not, by itself, a security boundary.
- Use environment overlays rather than duplicating base manifests.
- Do not promote to staging without validating the development deployment.

## 5. Container Image Standards

- Declare the image explicitly in the workload manifest.
- Prefer immutable image digests for controlled production workflows.
- Document the image source and version.
- Avoid unreviewed image changes.
- Validate image availability before rollout.
- Image provenance, vulnerability scanning, and signature verification
  are future platform controls unless independently implemented.

## 6. Resource Governance

- Define CPU and memory requests for workloads.
- Define limits where appropriate according to workload behavior
  and platform policy.
- Validate resource settings against available cluster capacity.
- Monitor scheduling failures and resource pressure.
- Do not interpret successful scheduling as proof of capacity safety.

The current NGINX lab does not yet implement resource requests or limits.
This is a tracked governance gap.

## 7. Health and Rollout

- Configure startup, readiness, and liveness probes as appropriate.
- Use Deployment rollout status to validate rollout completion.
- Check pod readiness, restart counts, and scheduling.
- Confirm the Service selector matches workload labels.
- Confirm Service endpoints are populated.
- Validate application-level behavior through the Service.
- Capture failure output and remediation when validation fails.

The current NGINX lab has rollout and HTTP validation evidence.
Dedicated health probes remain to be implemented.

## 8. Access and Security

- Apply least-privilege access for operators and workload identities.
- Avoid privileged containers unless explicitly justified and approved.
- Avoid unnecessary host access and host networking.
- Document required ports and exposure.
- Prefer internal Services unless external exposure is approved.
- Validate namespace and cluster permissions.
- Network policies and admission controls must be tested before
  claiming workload isolation.

These controls are not all implemented in the current kind lab.

## 9. Service and Networking

- Use a Service for stable workload access where required.
- Select only intended pods using labels.
- Validate Service ports and target ports.
- Confirm EndpointSlices contain ready backend endpoints.
- External exposure requires an explicit ingress or platform route
  design and security review.

The NGINX lab uses ClusterIP Services and has no external ingress.

## 10. Storage

- Declare persistent storage requirements before onboarding.
- Use PersistentVolumeClaims for persistent workload data.
- Validate access modes, capacity, mount paths, and recovery needs.
- Document backup and restore requirements.
- Do not treat container filesystem data as durable.

Persistent storage onboarding is not yet implemented in this lab.

## 11. Deployment Evidence and Acceptance

Record the following evidence:

- Source commit and manifest location.
- Environment and namespace.
- Deployment and Service status.
- Pod readiness and restart counts.
- Service endpoints.
- Rollout status.
- HTTP or workload-specific validation.
- Known warnings, limitations, and deviations.
- Rollback procedure and result where tested.

Acceptance requires successful manifest rendering, rollout validation,
and workload-specific checks. Missing controls must be explicitly
recorded as gaps rather than assumed satisfied.

## 12. Rollback

- Identify the last known-good manifest or source revision.
- Prefer reverting the declarative configuration change.
- Execute the rollback using the approved deployment workflow.
- Validate rollout status and workload behavior afterward.
- Record rollback evidence and any data recovery requirements.

Rollback has not yet been formally tested in the NGINX lab.

## 13. Onboarding Checklist

- [ ] Workload intake completed.
- [ ] Owner and operational contact identified.
- [ ] Environment and namespace selected.
- [ ] Image source and version documented.
- [ ] Resource requirements reviewed.
- [ ] Health checks defined.
- [ ] Security and access requirements reviewed.
- [ ] Service and exposure reviewed.
- [ ] Storage and recovery needs reviewed.
- [ ] Declarative manifests reviewed and rendered.
- [ ] CI validation passed.
- [ ] Deployment rollout completed.
- [ ] Pods and endpoints validated.
- [ ] Workload behavior tested.
- [ ] Rollback approach documented.
- [ ] Evidence and known gaps recorded.

## 14. Current NGINX Lab Mapping

| Standard area | Current evidence | Status |
|---|---|---|
| Intake and ownership | Lab workload identified; formal intake record pending | Partial |
| Environment | dev and staging overlays | Implemented |
| Declarative deployment | Kustomize base and overlays | Implemented |
| Image declaration | nginx:stable | Implemented; immutable digest pending |
| Resource governance | No requests/limits yet | Gap |
| Health probes | Rollout and readiness checks; dedicated probes absent | Partial |
| Service networking | ClusterIP and EndpointSlice validation | Implemented |
| Security controls | No complete workload security baseline | Gap |
| Storage | No PVC workload | Not implemented |
| CI | YAML lint and Kustomize build | Implemented |
| Rollback | Procedure documented; exercise pending | Gap |
| Evidence | GitHub and Notion evidence ledger | Implemented |

## 15. Status
Initial onboarding standard. Requirements, security controls,
resource policies, and acceptance criteria will be refined as
platform capabilities are implemented and validated.
