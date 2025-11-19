---
name: gitops
description: Master GitOps practices, CI/CD integration, Helm charts, Kustomize, and ArgoCD. Learn modern deployment patterns and infrastructure as code.
---

# GitOps & CI/CD

## Quick Start

### Create Helm Chart
```bash
# Create chart
helm create myapp

# Chart structure
myapp/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
```

### Helm Deployment
```bash
# Install release
helm install myapp ./myapp -n production --create-namespace

# Upgrade release
helm upgrade myapp ./myapp -n production

# Rollback
helm rollback myapp -n production

# List releases
helm list -n production
```

### Kustomize
```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: production

bases:
- base/

patchesStrategicMerge:
- replicas.yaml

images:
- name: myapp
  newTag: "1.2.0"
```

### ArgoCD Setup
```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Access ArgoCD
kubectl port-forward -n argocd svc/argocd-server 8080:443

# Create Application
kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/myorg/myapp
    path: k8s
    targetRevision: main
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
```

## Core Concepts

### CI/CD Pipelines
- **Build**: Compile code, run tests
- **Push**: Build and push container image
- **Deploy**: Apply manifests to cluster
- **Verify**: Run integration tests

### GitHub Actions Example
```yaml
name: Build and Deploy
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build image
      run: docker build -t myapp:${{ github.sha }} .
    - name: Push image
      run: docker push myapp:${{ github.sha }}
    - name: Update image
      run: |
        kubectl set image deployment/myapp \
          myapp=myapp:${{ github.sha }} -n production
```

### GitOps Principles
- **Git as truth**: All configs in Git
- **Declarative**: Describe desired state
- **Observed state**: Automated reconciliation
- **Immutable**: No manual changes

## Advanced Topics

### Multi-Environment
```
repo/
├── base/
│   ├── deployment.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── dev/
│   │   └── kustomization.yaml
│   ├── staging/
│   │   └── kustomization.yaml
│   └── prod/
│       └── kustomization.yaml
```

### Helm Values Management
- Values.yaml for defaults
- Environment-specific overrides
- Values from ConfigMaps
- Secrets integration

### ArgoCD Advanced
- Multi-cluster deployment
- ApplicationSets
- Sync waves
- Health assessment
- Notifications

## Resources
- [Helm Documentation](https://helm.sh/docs/)
- [Kustomize Documentation](https://kustomize.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitOps Best Practices](https://www.gitops.tech/)
