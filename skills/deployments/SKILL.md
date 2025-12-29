---
name: deployments
description: Master Kubernetes Deployments, StatefulSets, DaemonSets, and workload orchestration. Learn deployment patterns and container orchestration strategies.
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Kubernetes Deployments

## Quick Start

### Create a Simple Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

```bash
# Apply deployment
kubectl apply -f deployment.yaml

# Check deployment status
kubectl get deployments
kubectl describe deployment nginx-deployment

# Roll out status
kubectl rollout status deployment/nginx-deployment

# View replica sets
kubectl get replicasets
```

### Scaling & Updates
```bash
# Scale replicas
kubectl scale deployment nginx-deployment --replicas=5

# Update image
kubectl set image deployment/nginx-deployment nginx=nginx:1.22

# Check rollout history
kubectl rollout history deployment/nginx-deployment

# Rollback to previous version
kubectl rollout undo deployment/nginx-deployment
```

## Core Concepts

### Deployment Strategies
- **Rolling Update**: Gradual replacement (default)
- **Recreate**: Stop all, then start new
- **Canary**: Route percentage to new version
- **Blue-Green**: Run two versions simultaneously

### StatefulSets
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  replicas: 3
  serviceName: postgres
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:14
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
```

### DaemonSets
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
spec:
  selector:
    matchLabels:
      app: log-collector
  template:
    metadata:
      labels:
        app: log-collector
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:latest
        volumeMounts:
        - name: logs
          mountPath: /var/log
      volumes:
      - name: logs
        hostPath:
          path: /var/log
```

## Advanced Topics

### Pod Lifecycle
- Init containers
- Lifecycle hooks (preStart, preStop)
- Readiness/liveness probes
- Graceful termination

### Resource Management
- Resource requests and limits
- QoS classes
- Resource quotas
- Horizontal pod autoscaling

### Advanced Orchestration
- Operators
- Custom controllers
- Webhooks
- Status management

## Resources
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
