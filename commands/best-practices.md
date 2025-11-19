# /best-practices - Kubernetes Best Practices

Learn production-grade Kubernetes best practices and patterns.

## Container Image Best Practices

### Build Optimized Images
```dockerfile
# ✅ GOOD: Multi-stage build
FROM node:18 as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER node
EXPOSE 3000
CMD ["node", "server.js"]

# ❌ BAD: Single large image
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install
COPY . .
CMD ["node", "server.js"]
```

### Image Security
- ✅ Use specific base image tags
- ✅ Scan for vulnerabilities (Trivy, Grype)
- ✅ Run as non-root user
- ✅ Use minimal base images (alpine, distroless)
- ✅ Remove unnecessary packages

## Deployment Best Practices

### Resource Requests & Limits
```yaml
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
        # Always set requests and limits
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
```

### Health Checks
```yaml
containers:
- name: app
  livenessProbe:
    httpGet:
      path: /health
      port: 8080
    initialDelaySeconds: 30
    periodSeconds: 10
  readinessProbe:
    httpGet:
      path: /ready
      port: 8080
    initialDelaySeconds: 5
    periodSeconds: 5
```

### Graceful Shutdown
```yaml
spec:
  terminationGracePeriodSeconds: 30
  containers:
  - name: app
    lifecycle:
      preStop:
        exec:
          command: ["/bin/sh", "-c", "sleep 15 && kill -0 $$ || exit 0"]
```

## Security Best Practices

### Pod Security Context
```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
```

### Network Policies
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
    - podSelector:
        matchLabels:
          role: web
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          role: db
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
```

### RBAC Principles
- ✅ Use ServiceAccounts for pods
- ✅ Apply least privilege
- ✅ Separate roles by responsibility
- ✅ Use namespaces for isolation

## Networking Best Practices

### Service Configuration
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app
spec:
  # Use headless for StatefulSets
  clusterIP: None  # or omit for regular Service

  selector:
    app: myapp
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
```

### Ingress Setup
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app
  annotations:
    # Enable TLS
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - app.example.com
    secretName: app-tls
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app
            port:
              number: 80
```

## Storage Best Practices

### Persistent Volumes
- ✅ Use storage classes for dynamic provisioning
- ✅ Set appropriate access modes
- ✅ Implement backup strategy
- ✅ Monitor storage usage

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  storageClassName: fast
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

### StatefulSet Storage
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      storageClassName: fast
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 100Gi
```

## Monitoring & Observability

### Key Metrics to Monitor
- Pod CPU and memory usage
- API server latency
- Etcd performance
- Node resource availability
- Container restart count
- Network traffic

### Logging Strategy
- ✅ Centralize logs (ELK, Loki)
- ✅ Use structured logging
- ✅ Set retention policies
- ✅ Monitor log volume

### Alerting
- ✅ Alert on resource utilization
- ✅ Alert on error rates
- ✅ Alert on pod restarts
- ✅ Alert on node issues

## CI/CD Best Practices

### GitOps Workflow
```bash
# 1. Commit to source repo
git commit -m "feature: add new endpoint"
git push

# 2. CI builds and tests
# - Run tests
# - Build image
# - Push to registry

# 3. Update manifest
git commit -m "chore: update image tag"
git push

# 4. CD applies changes
# ArgoCD automatically syncs
```

### Deployment Strategy
- ✅ Use rolling updates
- ✅ Implement canary deployments
- ✅ Use blue-green for critical updates
- ✅ Automate rollback

## Checklist for Production

- [ ] Resource requests and limits set
- [ ] Health checks configured
- [ ] Security context applied
- [ ] Network policies in place
- [ ] Monitoring and logging enabled
- [ ] Backup strategy implemented
- [ ] RBAC configured
- [ ] Network policies enabled
- [ ] Pod security standards enabled
- [ ] Image scanning enabled
- [ ] CI/CD pipeline working
- [ ] High availability configured

---

Remember: Start simple, gradually add complexity based on needs.
