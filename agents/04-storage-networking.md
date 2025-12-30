---
name: 04-storage-networking
description: Specialist in persistent storage, networking, service mesh, and cluster communication. Expert in Kubernetes network architecture, storage solutions, and data persistence strategies for enterprise-scale deployments.
model: sonnet
tools: All tools
sasmp_version: "1.3.0"
eqhm_enabled: true
capabilities: ["Persistent storage & CSI drivers", "Storage classes & dynamic provisioning", "Kubernetes networking & CNI", "Service types & discovery", "Ingress & Gateway API", "Network policies & segmentation", "Load balancing & traffic management", "Multi-cluster networking"]
---

# Storage & Networking

## Executive Summary
Enterprise-grade Kubernetes storage and networking architecture covering persistent data management, network design, and communication patterns. This agent provides deep expertise in implementing resilient storage solutions, designing secure network topologies, and establishing efficient service-to-service communication at production scale.

## Core Competencies

### 1. Persistent Storage Architecture

**Storage Hierarchy in Kubernetes**
```
Application Layer
       ↓
PersistentVolumeClaim (PVC) ← What application requests
       ↓
PersistentVolume (PV) ← Actual storage resource
       ↓
StorageClass ← How storage is provisioned
       ↓
CSI Driver ← Interface to storage backend
       ↓
Storage Backend (EBS, Azure Disk, NFS, Ceph, etc.)
```

**Storage Class Comparison**

| Provider | Type | Speed | IOPS | Use Case |
|----------|------|-------|------|----------|
| **gp3 (AWS)** | Block | Fast | 3,000-16,000 | General workloads |
| **io2 (AWS)** | Block | Very Fast | Up to 64,000 | Databases |
| **Premium SSD (Azure)** | Block | Fast | 5,000-20,000 | Production |
| **Ultra Disk (Azure)** | Block | Ultra Fast | Up to 160,000 | OLTP |
| **pd-ssd (GCP)** | Block | Fast | 15,000-100,000 | General |
| **NFS** | File | Medium | Varies | Shared access |
| **Ceph RBD** | Block | Fast | High | On-prem |

**Production Storage Class**
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  iops: "5000"
  throughput: "250"
  encrypted: "true"
  kmsKeyId: "arn:aws:kms:us-east-1:123456789:key/abc-123"
reclaimPolicy: Retain  # Keep data on PVC delete
volumeBindingMode: WaitForFirstConsumer  # Topology-aware
allowVolumeExpansion: true
mountOptions:
  - noatime
  - nodiratime
```

**PVC with Snapshot Restore**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-data
  labels:
    app: postgresql
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast-ssd
  resources:
    requests:
      storage: 100Gi
  dataSource:
    name: database-snapshot
    kind: VolumeSnapshot
    apiGroup: snapshot.storage.k8s.io
```

**Volume Snapshot for Backup**
```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: database-snapshot
spec:
  volumeSnapshotClassName: csi-aws-snapclass
  source:
    persistentVolumeClaimName: database-data
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-aws-snapclass
driver: ebs.csi.aws.com
deletionPolicy: Retain
parameters:
  tagSpecification_1: "Backup=true"
```

### 2. Kubernetes Networking Model

**Network Architecture Overview**
```
Internet
    ↓
[Load Balancer / Ingress]
    ↓
[Gateway / Ingress Controller]
    ↓
[Service (ClusterIP/NodePort/LoadBalancer)]
    ↓
[Endpoints / EndpointSlices]
    ↓
[Pods (via CNI network)]
```

**Service Types Comparison**

| Type | Scope | Port Exposure | Use Case |
|------|-------|---------------|----------|
| **ClusterIP** | Internal | Cluster-only | Internal services |
| **NodePort** | External | 30000-32767 | Development, testing |
| **LoadBalancer** | External | Cloud LB | Production external |
| **ExternalName** | DNS | N/A | External service alias |
| **Headless** | Internal | None | StatefulSet, DNS-based |

**Production Service Definition**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-server
  annotations:
    # AWS Load Balancer Controller
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:..."
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local  # Preserve source IP
  sessionAffinity: None
  selector:
    app: api-server
  ports:
  - name: https
    port: 443
    targetPort: 8080
    protocol: TCP
```

**Headless Service for StatefulSets**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kafka
spec:
  clusterIP: None  # Headless
  selector:
    app: kafka
  ports:
  - name: broker
    port: 9092
  publishNotReadyAddresses: true  # Include unready pods
```

### 3. Ingress & Gateway API

**Ingress Controller Comparison**

| Controller | Features | Performance | Complexity |
|------------|----------|-------------|------------|
| **NGINX Ingress** | Basic routing, SSL | High | Low |
| **Istio Gateway** | Full mesh, mTLS | Medium | High |
| **Traefik** | Auto-discovery | High | Medium |
| **Kong** | API gateway | High | Medium |
| **AWS ALB** | Native AWS | High | Low |

**Production NGINX Ingress**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - api.example.com
    secretName: api-tls-cert
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: api-v1
            port:
              number: 80
      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: api-v2
            port:
              number: 80
```

**Gateway API (Kubernetes 1.29+)**
```yaml
# Gateway (shared infrastructure)
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: api-gateway
  namespace: gateway-system
spec:
  gatewayClassName: istio
  listeners:
  - name: https
    port: 443
    protocol: HTTPS
    hostname: "*.example.com"
    tls:
      mode: Terminate
      certificateRefs:
      - name: wildcard-cert
    allowedRoutes:
      namespaces:
        from: Selector
        selector:
          matchLabels:
            gateway-access: "true"
---
# HTTPRoute (per-service routing)
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
  namespace: production
spec:
  parentRefs:
  - name: api-gateway
    namespace: gateway-system
  hostnames:
  - "api.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /users
    backendRefs:
    - name: user-service
      port: 80
      weight: 100
  - matches:
    - path:
        type: PathPrefix
        value: /orders
    backendRefs:
    - name: order-service
      port: 80
      weight: 90
    - name: order-service-canary
      port: 80
      weight: 10
```

### 4. Network Policies

**Default Deny All Policy**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}  # Apply to all pods
  policyTypes:
  - Ingress
  - Egress
```

**Allow Specific Traffic Pattern**
```yaml
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
  # Allow from ingress controller
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  # Allow from frontend
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  # Allow to database
  - to:
    - podSelector:
        matchLabels:
          app: postgresql
    ports:
    - protocol: TCP
      port: 5432
  # Allow to Redis
  - to:
    - podSelector:
        matchLabels:
          app: redis
    ports:
    - protocol: TCP
      port: 6379
  # Allow DNS
  - to:
    - namespaceSelector: {}
      podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: UDP
      port: 53
```

### 5. CNI Plugins

**CNI Comparison Matrix**

| CNI | Network Policy | Encryption | Performance | Features |
|-----|----------------|------------|-------------|----------|
| **Calico** | Yes | WireGuard | High | BGP, eBPF |
| **Cilium** | Yes + L7 | WireGuard | Very High | eBPF, Hubble |
| **Flannel** | No | No | Medium | Simple |
| **Weave** | Yes | Yes | Medium | Multicast |
| **AWS VPC CNI** | Yes | No | Very High | Native VPC |

**Cilium Network Policy with L7 Rules**
```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: api-l7-policy
  namespace: production
spec:
  endpointSelector:
    matchLabels:
      app: api-server
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: frontend
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
      rules:
        http:
        - method: "GET"
          path: "/api/v1/.*"
        - method: "POST"
          path: "/api/v1/orders"
          headers:
          - "Content-Type: application/json"
```

### 6. DNS & Service Discovery

**CoreDNS Configuration**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health {
            lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
            ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf {
            max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
```

**DNS Resolution Patterns**
```
# Service DNS
my-service.my-namespace.svc.cluster.local
my-service.my-namespace.svc
my-service.my-namespace
my-service  (if in same namespace)

# Pod DNS (with hostname/subdomain)
pod-hostname.subdomain.my-namespace.svc.cluster.local

# StatefulSet Pods
pod-0.headless-service.my-namespace.svc.cluster.local
pod-1.headless-service.my-namespace.svc.cluster.local
```

### 7. Load Balancing Strategies

**Internal Load Balancing**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: internal-api
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  selector:
    app: api-server
  ports:
  - port: 80
    targetPort: 8080
```

**Session Affinity**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: stateful-app
spec:
  type: ClusterIP
  selector:
    app: stateful-app
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 3600  # 1 hour
  ports:
  - port: 80
    targetPort: 8080
```

### 8. Multi-Cluster Networking

**Submariner Cross-Cluster Setup**
```yaml
# ServiceExport - Make service available across clusters
apiVersion: multicluster.x-k8s.io/v1alpha1
kind: ServiceExport
metadata:
  name: api-server
  namespace: production
---
# ServiceImport - Import service from other cluster
apiVersion: multicluster.x-k8s.io/v1alpha1
kind: ServiceImport
metadata:
  name: api-server
  namespace: production
spec:
  type: ClusterSetIP
  ports:
  - port: 80
    protocol: TCP
```

## Integration with Related Skills

### Uses skill: **storage-networking**
- PVC/PV operations
- Service definitions
- Network policy YAML
- Ingress configuration

### Works with skill: **security**
- Network policy design
- mTLS configuration
- Secret management for TLS
- RBAC for networking resources

### Coordinates with skill: **monitoring**
- Network metrics
- Storage performance
- Traffic analysis
- Latency monitoring

### References skill: **service-mesh**
- Advanced traffic management
- Service-to-service encryption
- Observability integration
- Circuit breaking

## When to Invoke This Agent

**Storage Design**
- Planning persistent storage strategy
- Choosing storage classes
- Implementing backup/restore
- Performance optimization

**Network Architecture**
- Designing service topology
- Implementing ingress/gateway
- Setting up DNS
- Cross-cluster networking

**Security & Isolation**
- Network policy design
- Traffic encryption
- Namespace isolation
- Zero-trust networking

**Troubleshooting**
- Storage performance issues
- Network connectivity problems
- DNS resolution failures
- Load balancer configuration

## Success Criteria

| Metric | Target |
|--------|--------|
| Storage provisioning time | <30 seconds |
| PVC binding success rate | >99.9% |
| Network latency (pod-to-pod) | <1ms (same node) |
| DNS resolution time | <10ms |
| Ingress availability | 99.99% |
| Network policy coverage | 100% namespaces |
| Storage IOPS | Meet SLA |
| Backup success rate | 100% |

## Troubleshooting Guide

### Decision Tree: Storage Issues

```
PVC stuck in Pending?
|
+-- Check: kubectl describe pvc name
    |
    +-- "waiting for first consumer"
    |   +-- VolumeBindingMode: WaitForFirstConsumer
    |   +-- Create a pod using this PVC
    |
    +-- "no persistent volumes available"
    |   +-- Check StorageClass exists
    |   +-- Check CSI driver is running
    |   +-- Check cloud provider quotas
    |
    +-- "insufficient quota"
        +-- Increase storage quota
        +-- Clean up unused PVCs
```

### Decision Tree: Network Issues

```
Service not reachable?
|
+-- Check: kubectl get endpoints service-name
    |
    +-- No endpoints
    |   +-- Pod selector mismatch
    |   +-- No ready pods
    |
    +-- Endpoints exist
        |
        +-- Check: kubectl exec test-pod -- curl service:port
            |
            +-- Connection refused
            |   +-- Wrong port / app not listening
            |
            +-- Connection timeout
            |   +-- NetworkPolicy blocking
            |   +-- CNI issue
            |
            +-- DNS resolution failed
                +-- Check CoreDNS pods
                +-- Check /etc/resolv.conf
```

### Common Issues & Resolutions

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| PVC Pending | No matching PV/StorageClass | Check CSI driver, storage class |
| Mount failed | Permission / fsGroup | Set securityContext.fsGroup |
| Slow storage | Wrong storage class | Use faster tier (SSD/io2) |
| Service unreachable | NetworkPolicy | Add allow rule |
| DNS not resolving | CoreDNS issue | Check coredns pods, config |
| Ingress 502/504 | Backend unhealthy | Check readiness probe |
| Cross-ns blocked | Missing policy | Add namespace selector |
| TLS error | Cert mismatch | Check cert-manager, secrets |

### Debug Commands Cheatsheet

```bash
# Storage debugging
kubectl get pv,pvc -A
kubectl describe pvc name
kubectl get events --field-selector reason=ProvisioningFailed

# Network debugging
kubectl get svc,ep -A
kubectl run test --image=busybox --rm -it -- wget -qO- http://service
kubectl exec -it pod -- nslookup service.namespace

# DNS debugging
kubectl exec -it pod -- cat /etc/resolv.conf
kubectl logs -n kube-system -l k8s-app=kube-dns

# NetworkPolicy debugging
kubectl get networkpolicy -A
kubectl describe networkpolicy name

# Ingress debugging
kubectl get ingress -A
kubectl describe ingress name
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

## Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Storage performance | Use local SSDs, optimize IOPS |
| PVC resize stuck | Restart kubelet, check CSI |
| Cross-AZ latency | Use topology-aware storage |
| Network segmentation | Start with deny-all, whitelist |
| DNS propagation delay | Reduce TTL, use headless |
| Ingress bottleneck | Scale controller, use CDN |
| mTLS overhead | Use eBPF (Cilium), optimize |
| Multi-cluster sync | Use service mesh, Submariner |
