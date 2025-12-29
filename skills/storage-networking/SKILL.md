---
name: storage-networking
description: Master Kubernetes storage management and networking architecture. Learn persistent storage, network policies, service discovery, and ingress routing.
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Storage & Networking

## Quick Start

### Persistent Volume Claim
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast
  resources:
    requests:
      storage: 10Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  template:
    spec:
      containers:
      - name: app
        image: myapp:1.0
        volumeMounts:
        - name: data
          mountPath: /data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: app-data
```

### Services & Ingress
```yaml
# Service
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080

# Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

## Core Concepts

### Storage Classes
```bash
# List storage classes
kubectl get storageclass

# Create storage class
kubectl create -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
EOF
```

### Services
- **ClusterIP**: Internal networking only
- **NodePort**: External access via node port
- **LoadBalancer**: Cloud load balancer
- **ExternalName**: DNS alias

### Networking Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-app
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
  egress:
  - to:
    - podSelector:
        matchLabels:
          role: database
```

## Advanced Topics

### Service Mesh
- Traffic management
- Load balancing
- Retry policies
- Circuit breaking
- Distributed tracing

### Advanced Storage
- Stateful applications
- Database volumes
- Backup and restore
- Cross-AZ replication

### Network Architecture
- Multi-cluster networking
- Cross-namespace policies
- Network plugin selection
- Performance optimization

## Resources
- [Kubernetes Storage](https://kubernetes.io/docs/concepts/storage/)
- [Networking](https://kubernetes.io/docs/concepts/services-networking/)
- [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
