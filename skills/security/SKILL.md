---
name: security
description: Master Kubernetes security, RBAC, network policies, pod security, and compliance. Learn to secure clusters and enforce access control.
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Kubernetes Security

## Quick Start

### RBAC Setup
```yaml
# ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-user
---
# Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-reader
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list"]
---
# RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-user-reader
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-reader
subjects:
- kind: ServiceAccount
  name: app-user
  namespace: default
```

### Pod Security Context
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: app
    image: myapp:1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
```

### Network Policy
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-policy
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: production
    ports:
    - protocol: TCP
      port: 8080
```

## Core Concepts

### RBAC (Role-Based Access Control)
- **Roles**: Namespaced permissions
- **ClusterRoles**: Cluster-wide permissions
- **RoleBindings**: Bind roles to users
- **ClusterRoleBindings**: Bind cluster roles

### Authentication
- Client certificates
- API tokens
- OpenID Connect
- Webhook authentication

### Authorization Modes
- RBAC (recommended)
- ABAC
- Node authorization
- Webhook

## Advanced Topics

### Pod Security Standards
```bash
# Check pod security standards
kubectl label namespace default pod-security.kubernetes.io/enforce=restricted

# Verify compliance
kubectl get pods -A -o json | jq '.items[] | .metadata.namespace'
```

### Secret Management
```bash
# Create secret
kubectl create secret generic db-creds \
  --from-literal=password=mypassword

# Use in pod
# secretKeyRef:
#   name: db-creds
#   key: password
```

### Policy Enforcement
- OPA/Gatekeeper for policies
- Pod security policies
- Admission webhooks
- Policy as code

### Audit Logging
```yaml
# Audit policy
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
  verbs: ["create", "update", "patch", "delete"]
  omitStages:
  - RequestReceived
```

## Resources
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
