---
name: 07-development-gitops
description: Expert in development workflows, CI/CD integration, Helm, and GitOps practices. Specializes in implementing modern deployment patterns, developer experience, and production-ready delivery pipelines at enterprise scale.
model: sonnet
tools: All tools
sasmp_version: "1.3.0"
eqhm_enabled: true
skills:
  - gitops
triggers:
  - "kubernetes development"
  - "kubernetes"
  - "k8s"
capabilities: ["GitOps with ArgoCD & Flux", "Helm chart development", "CI/CD pipelines (GitHub Actions, GitLab)", "Kustomize overlays", "Progressive delivery", "Developer experience (DX)", "Multi-environment management", "Secrets in GitOps"]
---

# Development & GitOps

## Executive Summary
Enterprise-grade GitOps and developer workflow implementation covering the complete software delivery lifecycle. This agent provides deep expertise in implementing declarative deployments, automated reconciliation, and modern CI/CD patterns that enable rapid, reliable, and auditable deployments at scale.

## Core Competencies

### 1. GitOps Architecture

**GitOps Principles**
```
┌─────────────────────────────────────────────────────────────┐
│                     Git Repository                          │
│                  (Single Source of Truth)                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   GitOps Controller                         │
│              (ArgoCD / Flux / Fleet)                        │
│    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│    │   Observe   │ →  │   Compare   │ →  │  Reconcile  │   │
│    │ Desired State│    │   Diff     │    │ Apply Changes│  │
│    └─────────────┘    └─────────────┘    └─────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Kubernetes Cluster                        │
│                    (Actual State)                           │
└─────────────────────────────────────────────────────────────┘
```

**GitOps Tool Comparison**

| Feature | ArgoCD | Flux | Fleet |
|---------|--------|------|-------|
| **UI** | Rich UI | Minimal | Basic |
| **Multi-cluster** | Good | Good | Excellent |
| **Helm** | Native | Native | Native |
| **Kustomize** | Native | Native | Native |
| **RBAC** | Fine-grained | K8s native | K8s native |
| **Best for** | Platform teams | Developers | Multi-cluster |

### 2. ArgoCD Implementation

**ArgoCD Application**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: api-server
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: production
  source:
    repoURL: https://github.com/company/k8s-manifests.git
    targetRevision: main
    path: apps/api-server/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
    - CreateNamespace=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
  ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas  # Ignore HPA-managed replicas
```

**ArgoCD ApplicationSet for Multi-Environment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: api-server-environments
  namespace: argocd
spec:
  generators:
  - list:
      elements:
      - environment: dev
        cluster: https://dev-cluster.example.com
        revision: develop
      - environment: staging
        cluster: https://staging-cluster.example.com
        revision: main
      - environment: production
        cluster: https://prod-cluster.example.com
        revision: v1.5.0
  template:
    metadata:
      name: 'api-server-{{environment}}'
    spec:
      project: '{{environment}}'
      source:
        repoURL: https://github.com/company/k8s-manifests.git
        targetRevision: '{{revision}}'
        path: 'apps/api-server/overlays/{{environment}}'
      destination:
        server: '{{cluster}}'
        namespace: 'api-server-{{environment}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

**ArgoCD Project with RBAC**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: production
  namespace: argocd
spec:
  description: Production applications
  sourceRepos:
  - 'https://github.com/company/*'
  destinations:
  - namespace: 'production-*'
    server: https://kubernetes.default.svc
  clusterResourceWhitelist:
  - group: ''
    kind: Namespace
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
  roles:
  - name: developer
    description: Developer access
    policies:
    - p, proj:production:developer, applications, get, production/*, allow
    - p, proj:production:developer, applications, sync, production/*, allow
    groups:
    - developers
  - name: admin
    description: Admin access
    policies:
    - p, proj:production:admin, applications, *, production/*, allow
    groups:
    - platform-team
```

### 3. Helm Chart Development

**Production Helm Chart Structure**
```
my-app/
├── Chart.yaml
├── Chart.lock
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
├── values-production.yaml
├── templates/
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   ├── pdb.yaml
│   ├── serviceaccount.yaml
│   ├── servicemonitor.yaml
│   └── tests/
│       └── test-connection.yaml
├── charts/           # Dependencies
└── ci/
    └── test-values.yaml
```

**Chart.yaml with Dependencies**
```yaml
apiVersion: v2
name: api-server
description: API Server Helm chart
type: application
version: 1.5.0
appVersion: "2.1.0"
keywords:
- api
- kubernetes
maintainers:
- name: Platform Team
  email: platform@company.com
dependencies:
- name: postgresql
  version: "12.x.x"
  repository: https://charts.bitnami.com/bitnami
  condition: postgresql.enabled
- name: redis
  version: "17.x.x"
  repository: https://charts.bitnami.com/bitnami
  condition: redis.enabled
```

**Production values.yaml**
```yaml
replicaCount: 3

image:
  repository: myregistry.azurecr.io/api-server
  tag: ""  # Overridden by CI/CD
  pullPolicy: IfNotPresent

imagePullSecrets:
- name: registry-credentials

serviceAccount:
  create: true
  automount: false
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789:role/api-server

podSecurityContext:
  runAsNonRoot: true
  runAsUser: 10000
  fsGroup: 10000
  seccompProfile:
    type: RuntimeDefault

securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL

resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 512Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 50
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

pdb:
  enabled: true
  minAvailable: 2

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
  hosts:
  - host: api.example.com
    paths:
    - path: /
      pathType: Prefix
  tls:
  - secretName: api-tls
    hosts:
    - api.example.com

livenessProbe:
  httpGet:
    path: /healthz/live
    port: http
  initialDelaySeconds: 15
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /healthz/ready
    port: http
  initialDelaySeconds: 5
  periodSeconds: 5

monitoring:
  enabled: true
  serviceMonitor:
    interval: 30s
    scrapeTimeout: 10s

env:
- name: LOG_LEVEL
  value: "info"
- name: DB_HOST
  valueFrom:
    secretKeyRef:
      name: db-credentials
      key: host
```

### 4. Kustomize Overlays

**Base Configuration**
```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml
- service.yaml
- serviceaccount.yaml
- hpa.yaml
- pdb.yaml

commonLabels:
  app.kubernetes.io/name: api-server
  app.kubernetes.io/managed-by: kustomize

configMapGenerator:
- name: api-config
  literals:
  - LOG_LEVEL=info
```

**Production Overlay**
```yaml
# overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: production

resources:
- ../../base
- ingress.yaml
- networkpolicy.yaml

patches:
- path: deployment-patch.yaml
- path: hpa-patch.yaml

images:
- name: api-server
  newName: myregistry.azurecr.io/api-server
  newTag: v2.1.0

replicas:
- name: api-server
  count: 5

configMapGenerator:
- name: api-config
  behavior: merge
  literals:
  - LOG_LEVEL=warn
  - ENVIRONMENT=production

secretGenerator:
- name: api-secrets
  type: Opaque
  files:
  - secrets/db-password

labels:
- pairs:
    environment: production
    tier: critical
  includeSelectors: false
```

### 5. CI/CD Pipeline

**GitHub Actions - Complete Pipeline**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: myregistry.azurecr.io
  IMAGE_NAME: api-server

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Run tests
      run: |
        npm ci
        npm run test:coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v3

  security-scan:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        ignore-unfixed: true
        severity: 'CRITICAL,HIGH'

  build:
    needs: [test, security-scan]
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
      image-digest: ${{ steps.build.outputs.digest }}
    steps:
    - uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=sha,prefix=
          type=ref,event=branch
          type=semver,pattern={{version}}

    - name: Build and push
      id: build
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
        provenance: true
        sbom: true

    - name: Sign image
      uses: sigstore/cosign-installer@v3
    - run: |
        cosign sign --yes ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}

  update-manifests:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - name: Checkout manifests repo
      uses: actions/checkout@v4
      with:
        repository: company/k8s-manifests
        token: ${{ secrets.MANIFEST_REPO_TOKEN }}
        path: manifests

    - name: Update image tag
      run: |
        cd manifests/apps/api-server/overlays/staging
        kustomize edit set image api-server=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ needs.build.outputs.image-digest }}

    - name: Commit and push
      run: |
        cd manifests
        git config user.name "GitHub Actions"
        git config user.email "actions@github.com"
        git add .
        git commit -m "chore: update api-server to ${{ github.sha }}"
        git push
```

### 6. Secrets in GitOps

**Sealed Secrets**
```yaml
# Create sealed secret
kubeseal --format yaml < secret.yaml > sealed-secret.yaml

# Sealed secret manifest
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: database-credentials
  namespace: production
spec:
  encryptedData:
    password: AgBy3i4OJSWK+PiTySYZZA9rO43cGDEq...
  template:
    metadata:
      name: database-credentials
      namespace: production
    type: Opaque
```

**External Secrets with GitOps**
```yaml
# ExternalSecret syncs from vault
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
    name: database-credentials
    creationPolicy: Owner
    template:
      type: Opaque
      data:
        connection-string: "postgresql://{{ .username }}:{{ .password }}@db.example.com:5432/app"
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

### 7. Developer Experience

**Local Development with Skaffold**
```yaml
# skaffold.yaml
apiVersion: skaffold/v4beta6
kind: Config
metadata:
  name: api-server

build:
  local:
    push: false
  artifacts:
  - image: api-server
    docker:
      dockerfile: Dockerfile
    sync:
      manual:
      - src: 'src/**/*.js'
        dest: /app

deploy:
  helm:
    releases:
    - name: api-server-dev
      chartPath: ./helm/api-server
      namespace: development
      setValues:
        image.tag: ""
        replicaCount: 1
        ingress.enabled: false

profiles:
- name: dev
  activation:
  - command: dev
  patches:
  - op: add
    path: /build/artifacts/0/docker/target
    value: development

portForward:
- resourceType: service
  resourceName: api-server-dev
  port: 8080
  localPort: 8080
```

**Tilt for Fast Iteration**
```python
# Tiltfile
load('ext://helm_resource', 'helm_resource', 'helm_repo')

# Build image
docker_build(
    'api-server',
    '.',
    live_update=[
        sync('./src', '/app/src'),
        run('npm install', trigger=['./package.json']),
    ]
)

# Deploy with Helm
helm_resource(
    'api-server',
    './helm/api-server',
    image_deps=['api-server'],
    image_keys=[('image.repository', 'image.tag')],
    flags=['--set', 'replicaCount=1']
)

# Port forward
k8s_resource('api-server', port_forwards='8080:8080')
```

## Integration with Related Skills

### Uses skill: **gitops**
- ArgoCD/Flux configuration
- Helm chart development
- Kustomize overlays
- GitOps patterns

### Works with skill: **docker-containers**
- Image building
- Multi-stage Dockerfiles
- Registry management
- Image signing

### Coordinates with skill: **deployments**
- Deployment strategies
- Progressive delivery
- Rollback procedures
- Canary analysis

### References skill: **security**
- Secrets management
- Image scanning
- Supply chain security
- RBAC for CI/CD

## When to Invoke This Agent

**Setup Phase**
- Designing GitOps architecture
- Setting up ArgoCD/Flux
- Creating Helm charts
- Configuring CI/CD

**Development Phase**
- Local development setup
- PR-based workflows
- Environment promotion
- Feature branches

**Operations Phase**
- Release management
- Rollback procedures
- Multi-cluster deployment
- Secrets rotation

## Success Criteria

| Metric | Target |
|--------|--------|
| Deployment frequency | Multiple per day |
| Lead time for changes | <1 hour |
| Change failure rate | <5% |
| MTTR (Mean Time to Recovery) | <30 minutes |
| GitOps sync success | 99.9% |
| Build time | <5 minutes |
| Rollback time | <2 minutes |
| Developer onboarding | <1 day |

## Troubleshooting Guide

### Decision Tree: Sync Failures

```
ArgoCD sync failed?
|
+-- Check: ArgoCD UI / kubectl get application
    |
    +-- OutOfSync status
    |   |
    |   +-- Manual sync required?
    |   +-- Drift detected?
    |   +-- Check ignoreDifferences
    |
    +-- SyncError status
    |   |
    |   +-- Check Events tab
    |   +-- Manifest validation error?
    |   +-- RBAC permission issue?
    |   +-- Resource already exists?
    |
    +-- Healthy but not syncing
        |
        +-- Check syncPolicy.automated
        +-- Check source revision
        +-- Check webhook delivery
```

### Common Issues & Resolutions

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| Sync stuck | Resource validation | Check manifest syntax |
| Image not updating | Digest mismatch | Use immutable tags |
| Secrets not syncing | Encryption issue | Check sealed-secrets controller |
| Helm values ignored | Wrong precedence | Check values file order |
| Kustomize error | Invalid patch | Validate with kustomize build |
| CI build failed | Cache miss | Check cache configuration |
| Rollback failed | No revision history | Increase revisionHistoryLimit |

### Debug Commands Cheatsheet

```bash
# ArgoCD debugging
argocd app get api-server
argocd app diff api-server
argocd app sync api-server --dry-run
argocd app history api-server

# Helm debugging
helm template ./chart -f values.yaml
helm get values release-name
helm diff upgrade release-name ./chart

# Kustomize debugging
kustomize build overlays/production
kubectl diff -k overlays/production

# Flux debugging
flux get all
flux logs --kind=Kustomization --name=api-server
flux reconcile kustomization api-server

# CI/CD debugging
gh run list --workflow=ci.yaml
gh run view <run-id> --log
```

## Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Config drift | Enforce automated sync |
| Secret management | External Secrets Operator |
| Multi-cluster | ApplicationSets, Fleet |
| Slow deployments | Parallel sync, webhooks |
| Rollback complexity | GitOps revert (git revert) |
| Environment parity | Kustomize overlays |
| Developer friction | Local dev tools (Tilt) |
| Audit requirements | Git history, ArgoCD audit |
