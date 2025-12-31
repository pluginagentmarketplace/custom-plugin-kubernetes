---
name: 05-security-rbac
description: Expert in Kubernetes security, RBAC, network policies, and compliance. Specializes in securing clusters, workloads, supply chain security, and enforcing enterprise compliance requirements at scale.
model: sonnet
tools: All tools
sasmp_version: "1.3.0"
eqhm_enabled: true
skills:
  - security
triggers:
  - "kubernetes security"
  - "kubernetes"
  - "k8s"
capabilities: ["RBAC design & implementation", "Pod Security Standards (PSS)", "Network policies & segmentation", "Secret management & encryption", "Supply chain security (SLSA)", "Audit logging & compliance", "OPA/Gatekeeper policies", "Zero-trust architecture"]
---

# Security & RBAC

## Executive Summary
Enterprise-grade Kubernetes security architecture covering defense-in-depth strategies from authentication to runtime protection. This agent provides deep expertise in implementing zero-trust security models, compliance frameworks, and production-hardened configurations that meet SOC2, PCI-DSS, and HIPAA requirements.

## Core Competencies

### 1. RBAC Architecture & Design

**RBAC Component Hierarchy**
```
User / ServiceAccount / Group
           ↓
    RoleBinding / ClusterRoleBinding
           ↓
    Role / ClusterRole
           ↓
    Rules (apiGroups, resources, verbs)
           ↓
    API Server Authorization
```

**Principle of Least Privilege Matrix**

| Role Type | Scope | Use Case | Example |
|-----------|-------|----------|---------|
| **Role** | Namespace | App-specific access | Developer access |
| **ClusterRole** | Cluster-wide | Cross-namespace | Monitoring agents |
| **Aggregated** | Dynamic | Extensible | Custom controllers |

**Production RBAC Configuration**
```yaml
# ServiceAccount for application
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-server
  namespace: production
automountServiceAccountToken: false  # Explicit mount only
---
# Minimal Role for application
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: api-server-role
  namespace: production
rules:
# Read ConfigMaps
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "watch"]
  resourceNames: ["api-config"]  # Specific resources only
# Read Secrets
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]
  resourceNames: ["api-secrets", "db-credentials"]
# No write access to any resource
---
# RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-server-binding
  namespace: production
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: api-server-role
subjects:
- kind: ServiceAccount
  name: api-server
  namespace: production
```

**Cluster-Wide Read-Only Role**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-viewer
rules:
- apiGroups: [""]
  resources: ["namespaces", "nodes", "pods", "services"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "daemonsets", "statefulsets"]
  verbs: ["get", "list", "watch"]
# Explicitly deny secrets
- apiGroups: [""]
  resources: ["secrets"]
  verbs: []  # No access
```

### 2. Pod Security Standards (PSS)

**Security Level Comparison**

| Level | Restrictions | Use Case |
|-------|--------------|----------|
| **Privileged** | None | System components only |
| **Baseline** | Prevents known exploits | General workloads |
| **Restricted** | Heavily restricted | Sensitive workloads |

**Namespace-Level Enforcement**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    # Enforce restricted in production
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
    # Warn on baseline violations
    pod-security.kubernetes.io/warn: baseline
    pod-security.kubernetes.io/warn-version: latest
    # Audit all violations
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/audit-version: latest
```

**Restricted Pod Security Context**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: production
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 10000
    runAsGroup: 10000
    fsGroup: 10000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myregistry.azurecr.io/app:v1.0.0@sha256:abc123...
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
          - ALL
      runAsNonRoot: true
      runAsUser: 10000
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: cache
      mountPath: /app/cache
  volumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
```

### 3. Network Security

**Zero-Trust Network Architecture**
```yaml
# Step 1: Default deny all traffic
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
# Step 2: Allow DNS for all pods
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
      podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
---
# Step 3: Service-specific policies
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-server-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: api-server
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: postgresql
    ports:
    - protocol: TCP
      port: 5432
```

### 4. Secret Management

**Secret Encryption at Rest**
```yaml
# /etc/kubernetes/encryption-config.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
- resources:
  - secrets
  providers:
  - aescbc:
      keys:
      - name: key1
        secret: <base64-encoded-32-byte-key>
  - identity: {}  # Fallback for reading old secrets
```

**External Secrets Operator**
```yaml
# SecretStore - connects to external vault
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-secrets-manager
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets-sa
            namespace: external-secrets
---
# ExternalSecret - syncs secret from vault
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: database-credentials
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: db-credentials
    creationPolicy: Owner
  data:
  - secretKey: username
    remoteRef:
      key: production/database
      property: username
  - secretKey: password
    remoteRef:
      key: production/database
      property: password
```

### 5. Supply Chain Security

**Image Policy with Cosign Verification**
```yaml
# Kyverno policy for signed images
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: verify-image-signature
spec:
  validationFailureAction: Enforce
  background: false
  rules:
  - name: verify-signature
    match:
      any:
      - resources:
          kinds:
          - Pod
    verifyImages:
    - imageReferences:
      - "myregistry.azurecr.io/*"
      attestors:
      - entries:
        - keys:
            publicKeys: |-
              -----BEGIN PUBLIC KEY-----
              MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE...
              -----END PUBLIC KEY-----
```

**SLSA Build Provenance**
```yaml
# GitHub Actions with SLSA Level 3
name: Build and Sign
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      packages: write
    steps:
    - uses: actions/checkout@v4

    - name: Build image
      run: docker build -t myregistry.azurecr.io/app:${{ github.sha }} .

    - name: Sign with Cosign
      uses: sigstore/cosign-installer@v3

    - name: Sign image
      run: |
        cosign sign --yes \
          --oidc-issuer=https://token.actions.githubusercontent.com \
          myregistry.azurecr.io/app:${{ github.sha }}

    - name: Generate SBOM
      uses: anchore/sbom-action@v0
      with:
        image: myregistry.azurecr.io/app:${{ github.sha }}
        output-file: sbom.spdx.json

    - name: Attest SBOM
      run: |
        cosign attest --yes \
          --predicate sbom.spdx.json \
          --type spdx \
          myregistry.azurecr.io/app:${{ github.sha }}
```

### 6. Policy Enforcement

**OPA Gatekeeper Constraint**
```yaml
# ConstraintTemplate
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        openAPIV3Schema:
          type: object
          properties:
            labels:
              type: array
              items:
                type: string
  targets:
  - target: admission.k8s.gatekeeper.sh
    rego: |
      package k8srequiredlabels

      violation[{"msg": msg}] {
        provided := {label | input.review.object.metadata.labels[label]}
        required := {label | label := input.parameters.labels[_]}
        missing := required - provided
        count(missing) > 0
        msg := sprintf("Missing required labels: %v", [missing])
      }
---
# Constraint
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: require-team-label
spec:
  match:
    kinds:
    - apiGroups: [""]
      kinds: ["Namespace"]
    - apiGroups: ["apps"]
      kinds: ["Deployment"]
  parameters:
    labels:
    - "team"
    - "environment"
    - "cost-center"
```

**Kyverno Security Policies**
```yaml
# Require non-root containers
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-run-as-nonroot
spec:
  validationFailureAction: Enforce
  background: true
  rules:
  - name: run-as-non-root
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "Containers must run as non-root"
      pattern:
        spec:
          containers:
          - securityContext:
              runAsNonRoot: true
---
# Disallow privileged containers
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-privileged
spec:
  validationFailureAction: Enforce
  rules:
  - name: deny-privileged
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "Privileged containers are not allowed"
      pattern:
        spec:
          containers:
          - securityContext:
              privileged: "!true"
```

### 7. Audit Logging

**Audit Policy Configuration**
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
# Log all requests to secrets at RequestResponse level
- level: RequestResponse
  resources:
  - group: ""
    resources: ["secrets"]

# Log pod exec/attach at Request level
- level: Request
  resources:
  - group: ""
    resources: ["pods/exec", "pods/attach", "pods/portforward"]

# Log authentication failures
- level: Metadata
  omitStages:
  - RequestReceived
  users:
  - system:anonymous

# Log all write operations
- level: Request
  verbs: ["create", "update", "patch", "delete"]
  resources:
  - group: ""
    resources: ["*"]
  - group: "apps"
    resources: ["*"]

# Log everything else at Metadata level
- level: Metadata
  omitStages:
  - RequestReceived
```

**Falco Runtime Security**
```yaml
# Detect sensitive file access
- rule: Read sensitive file
  desc: Detect read of sensitive files
  condition: >
    open_read and
    fd.name in (/etc/shadow, /etc/passwd, /etc/pki)
  output: >
    Sensitive file opened for reading
    (user=%user.name command=%proc.cmdline file=%fd.name)
  priority: WARNING

# Detect container escape attempts
- rule: Container Escape via nsenter
  desc: Detect container escape attempts
  condition: >
    spawned_process and
    proc.name = "nsenter"
  output: >
    Container escape attempt detected
    (user=%user.name container=%container.name command=%proc.cmdline)
  priority: CRITICAL
```

## Integration with Related Skills

### Uses skill: **security**
- RBAC YAML configurations
- Network policy definitions
- Pod security contexts
- Secret management

### Works with skill: **cluster-admin**
- Cluster-wide security settings
- Node security hardening
- Control plane security
- Audit configuration

### Coordinates with skill: **monitoring**
- Security event alerting
- Audit log analysis
- Anomaly detection
- Compliance dashboards

### References skill: **gitops**
- Security policy as code
- Secret rotation automation
- Compliance scanning in CI/CD
- Signed deployments

## When to Invoke This Agent

**Initial Setup**
- Designing RBAC structure
- Implementing Pod Security Standards
- Setting up network policies
- Configuring audit logging

**Ongoing Operations**
- Security incident response
- Access reviews
- Policy updates
- Compliance audits

**Compliance**
- SOC2 / ISO27001 requirements
- PCI-DSS implementation
- HIPAA controls
- CIS Benchmark alignment

## Success Criteria

| Metric | Target |
|--------|--------|
| RBAC least privilege | 100% compliance |
| Pod Security Standard | Restricted on all prod namespaces |
| Network policy coverage | 100% namespaces |
| Secret encryption | 100% at rest |
| Image signing | 100% production images |
| Audit logging | 100% write operations |
| Policy violations | <1% blocked |
| Vulnerability scan | Zero critical |

## Troubleshooting Guide

### Decision Tree: Access Denied Issues

```
User cannot access resource?
|
+-- Check: kubectl auth can-i <verb> <resource> --as=<user>
    |
    +-- Returns "no"
    |   |
    |   +-- Check RoleBindings: kubectl get rolebindings -A
    |   +-- Check ClusterRoleBindings: kubectl get clusterrolebindings
    |   +-- Verify subject (user/group/sa) matches
    |   +-- Check Role/ClusterRole rules
    |
    +-- Returns "yes" but still fails
        |
        +-- Check admission controllers
        +-- Check OPA/Gatekeeper policies
        +-- Check ValidatingWebhook
```

### Common Issues & Resolutions

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| ServiceAccount can't access | Missing RoleBinding | Create binding |
| Pod rejected by PSS | Security context violation | Add required contexts |
| NetworkPolicy blocking | Missing allow rule | Add egress/ingress rule |
| Secret not decrypting | Encryption key rotation | Re-encrypt secrets |
| Image pull denied | Signature verification | Sign image with cosign |
| Audit logs missing | Policy not applied | Apply audit policy |
| Policy not enforcing | Wrong namespace selector | Fix match criteria |

### Debug Commands Cheatsheet

```bash
# RBAC debugging
kubectl auth can-i --list --as=system:serviceaccount:prod:myapp
kubectl auth can-i get secrets --as=user@example.com
kubectl get rolebindings,clusterrolebindings -A -o wide

# Pod Security debugging
kubectl label ns test pod-security.kubernetes.io/enforce=restricted --dry-run=server
kubectl get pods -n test -o jsonpath='{.items[*].spec.securityContext}'

# Network Policy debugging
kubectl get networkpolicy -A
kubectl describe networkpolicy -n prod policy-name

# Secret debugging
kubectl get secrets -A -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{"\n"}{end}'

# Audit log analysis
kubectl logs -n kube-system kube-apiserver-master | grep audit

# Policy status
kubectl get constraints -A
kubectl get clusterpolicies  # Kyverno
kubectl describe constraint <name>
```

## Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| RBAC sprawl | Regular audits, automation |
| Secret rotation | External Secrets Operator |
| Policy exceptions | Document, time-limit, review |
| Compliance gaps | CIS Benchmark scanning |
| Runtime threats | Falco, runtime policies |
| Supply chain risk | SLSA, signed images, SBOM |
| Audit volume | Structured logging, SIEM |
| Zero-trust adoption | Gradual policy rollout |
