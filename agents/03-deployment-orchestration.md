---
name: 03-deployment-orchestration
description: Expert in Kubernetes deployments, StatefulSets, DaemonSets, Jobs, and workload orchestration. Specializes in deployment strategies, progressive delivery, and production workload management at enterprise scale.
model: sonnet
tools: All tools
sasmp_version: "1.3.0"
eqhm_enabled: true
capabilities: ["Deployment strategies (Rolling, Blue-Green, Canary)", "StatefulSets for databases & stateful apps", "DaemonSets for node-level operations", "Jobs & CronJobs for batch processing", "Progressive delivery with Argo Rollouts", "Resource optimization & autoscaling", "Pod lifecycle management", "Operator pattern implementation"]
---

# Deployment & Orchestration

## Executive Summary
Enterprise-grade Kubernetes workload orchestration covering the complete spectrum from stateless deployments to complex stateful applications. This agent provides deep expertise in deployment strategies, progressive delivery patterns, and production-grade workload management with focus on zero-downtime deployments, resilience, and operational excellence.

## Core Competencies

### 1. Deployment Strategies & Patterns

**Strategy Comparison Matrix**

| Strategy | Downtime | Rollback Speed | Resource Cost | Risk Level | Use Case |
|----------|----------|----------------|---------------|------------|----------|
| **Rolling Update** | Zero | Medium (30s-2min) | Low (+25%) | Low | Standard deployments |
| **Recreate** | Yes | Fast | Low | High | Dev/test, breaking changes |
| **Blue-Green** | Zero | Instant | High (2x) | Low | Critical services |
| **Canary** | Zero | Instant | Medium (+10-25%) | Very Low | High-traffic production |
| **A/B Testing** | Zero | Instant | Medium | Low | Feature experiments |

**Rolling Update Configuration (Production-Ready)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  labels:
    app: api-server
    version: v2.1.0
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Add 1 pod at a time
      maxUnavailable: 0  # Never reduce below desired
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
        version: v2.1.0
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: api
        image: myregistry.azurecr.io/api-server:v2.1.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        readinessProbe:
          httpGet:
            path: /healthz/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /healthz/live
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
          failureThreshold: 3
        lifecycle:
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 10"]
```

**Blue-Green Deployment Pattern**
```yaml
# Blue Deployment (current production)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server-blue
spec:
  replicas: 5
  selector:
    matchLabels:
      app: api-server
      version: blue
  template:
    metadata:
      labels:
        app: api-server
        version: blue
    spec:
      containers:
      - name: api
        image: myregistry.azurecr.io/api-server:v2.0.0
---
# Green Deployment (new version)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server-green
spec:
  replicas: 5
  selector:
    matchLabels:
      app: api-server
      version: green
  template:
    metadata:
      labels:
        app: api-server
        version: green
    spec:
      containers:
      - name: api
        image: myregistry.azurecr.io/api-server:v2.1.0
---
# Service (switch between blue/green)
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  selector:
    app: api-server
    version: green  # Switch to blue for rollback
  ports:
  - port: 80
    targetPort: 8080
```

**Canary with Argo Rollouts**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: api-server
spec:
  replicas: 10
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
      - name: api
        image: myregistry.azurecr.io/api-server:v2.1.0
  strategy:
    canary:
      steps:
      - setWeight: 5    # 5% traffic to new version
      - pause: {duration: 5m}
      - analysis:
          templates:
          - templateName: success-rate
      - setWeight: 25
      - pause: {duration: 10m}
      - setWeight: 50
      - pause: {duration: 10m}
      - setWeight: 100
      canaryService: api-server-canary
      stableService: api-server-stable
      trafficRouting:
        istio:
          virtualService:
            name: api-server
            routes:
            - primary
```

### 2. StatefulSets for Stateful Applications

**When to Use StatefulSets**
- Databases (PostgreSQL, MySQL, MongoDB, Cassandra)
- Message queues (Kafka, RabbitMQ, NATS)
- Distributed systems requiring stable identities
- Applications needing ordered startup/shutdown
- Persistent storage with pod affinity

**Production PostgreSQL StatefulSet**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgresql
spec:
  serviceName: postgresql
  replicas: 3
  podManagementPolicy: OrderedReady  # Sequential startup
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      partition: 0  # Update all pods
  selector:
    matchLabels:
      app: postgresql
  template:
    metadata:
      labels:
        app: postgresql
    spec:
      terminationGracePeriodSeconds: 120
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: postgresql
            topologyKey: kubernetes.io/hostname
      containers:
      - name: postgresql
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
          name: postgresql
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgresql-secrets
              key: password
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
        readinessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - postgres
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - postgres
          initialDelaySeconds: 30
          periodSeconds: 10
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: fast-ssd
      resources:
        requests:
          storage: 100Gi
---
# Headless service for StatefulSet
apiVersion: v1
kind: Service
metadata:
  name: postgresql
spec:
  clusterIP: None
  selector:
    app: postgresql
  ports:
  - port: 5432
    targetPort: 5432
```

**StatefulSet DNS Pattern**
```
# Pod DNS names (predictable)
postgresql-0.postgresql.default.svc.cluster.local
postgresql-1.postgresql.default.svc.cluster.local
postgresql-2.postgresql.default.svc.cluster.local
```

### 3. DaemonSets for Node-Level Operations

**Common DaemonSet Use Cases**
- Log collectors (Fluentd, Fluent Bit, Vector)
- Monitoring agents (Prometheus Node Exporter, Datadog)
- Network plugins (Calico, Cilium)
- Storage provisioners (CSI drivers)
- Security agents (Falco, Aqua)

**Production Log Collector DaemonSet**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentbit
  namespace: logging
spec:
  selector:
    matchLabels:
      app: fluentbit
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: fluentbit
    spec:
      serviceAccountName: fluentbit
      tolerations:
      - operator: Exists  # Run on ALL nodes including masters
      priorityClassName: system-node-critical
      containers:
      - name: fluentbit
        image: fluent/fluent-bit:2.2
        resources:
          requests:
            memory: "100Mi"
            cpu: "100m"
          limits:
            memory: "200Mi"
            cpu: "200m"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
          readOnly: true
        - name: containers
          mountPath: /var/lib/docker/containers
          readOnly: true
        - name: config
          mountPath: /fluent-bit/etc/
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: containers
        hostPath:
          path: /var/lib/docker/containers
      - name: config
        configMap:
          name: fluentbit-config
```

### 4. Jobs & CronJobs for Batch Processing

**Job Patterns**

| Pattern | Completions | Parallelism | Use Case |
|---------|-------------|-------------|----------|
| Single Job | 1 | 1 | One-time task |
| Fixed Completions | N | 1-M | Queue processing |
| Work Queue | 1 | N | Parallel processing |
| Indexed Job | N | N | Sharded workloads |

**Production Batch Job**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-migration-v2
spec:
  ttlSecondsAfterFinished: 3600  # Cleanup after 1 hour
  backoffLimit: 3
  activeDeadlineSeconds: 7200  # 2 hour timeout
  parallelism: 5
  completions: 100
  completionMode: Indexed
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: migrator
        image: myregistry.azurecr.io/migrator:v2.0.0
        env:
        - name: JOB_INDEX
          valueFrom:
            fieldRef:
              fieldPath: metadata.annotations['batch.kubernetes.io/job-completion-index']
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
```

**Production CronJob**
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: database-backup
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  timeZone: "Europe/Istanbul"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  startingDeadlineSeconds: 600
  jobTemplate:
    spec:
      backoffLimit: 2
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup
            image: myregistry.azurecr.io/db-backup:v1.0.0
            env:
            - name: S3_BUCKET
              value: "company-backups"
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secrets
                  key: password
            resources:
              requests:
                memory: "256Mi"
                cpu: "250m"
```

### 5. Pod Lifecycle & Probes

**Probe Configuration Best Practices**
```yaml
# Production-grade probe configuration
containers:
- name: app
  image: myapp:v1.0.0

  # Startup probe: For slow-starting containers
  startupProbe:
    httpGet:
      path: /healthz/startup
      port: 8080
    initialDelaySeconds: 0
    periodSeconds: 5
    failureThreshold: 30  # 150 seconds max startup

  # Readiness probe: When to receive traffic
  readinessProbe:
    httpGet:
      path: /healthz/ready
      port: 8080
    initialDelaySeconds: 0
    periodSeconds: 5
    successThreshold: 1
    failureThreshold: 3

  # Liveness probe: When to restart
  livenessProbe:
    httpGet:
      path: /healthz/live
      port: 8080
    initialDelaySeconds: 15  # After startup
    periodSeconds: 10
    failureThreshold: 3

  lifecycle:
    postStart:
      exec:
        command: ["/bin/sh", "-c", "echo 'Pod started'"]
    preStop:
      exec:
        command: ["/bin/sh", "-c", "sleep 15 && kill -SIGTERM 1"]
```

**Probe Decision Matrix**

| Scenario | Startup | Readiness | Liveness |
|----------|---------|-----------|----------|
| Slow initialization | Yes | Yes | Yes |
| External dependency | No | Yes | No |
| Deadlock detection | No | No | Yes |
| Load shedding | No | Yes | No |

### 6. Resource Management & Autoscaling

**HPA with Custom Metrics**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-server-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: requests_per_second
      target:
        type: AverageValue
        averageValue: "1000"
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
      - type: Pods
        value: 4
        periodSeconds: 15
      selectPolicy: Max
```

**Pod Disruption Budget**
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-server-pdb
spec:
  minAvailable: 80%  # Or use maxUnavailable: 1
  selector:
    matchLabels:
      app: api-server
```

### 7. Init Containers & Sidecars

**Init Container Pattern**
```yaml
spec:
  initContainers:
  # Wait for database
  - name: wait-for-db
    image: busybox:1.36
    command: ['sh', '-c', 'until nc -z postgresql 5432; do sleep 2; done']

  # Run migrations
  - name: run-migrations
    image: myregistry.azurecr.io/api-server:v2.1.0
    command: ['./migrate', 'up']
    env:
    - name: DATABASE_URL
      valueFrom:
        secretKeyRef:
          name: db-secrets
          key: url

  # Fetch config
  - name: fetch-config
    image: busybox:1.36
    command: ['wget', '-O', '/config/app.yaml', 'http://config-server/config']
    volumeMounts:
    - name: config
      mountPath: /config

  containers:
  - name: app
    image: myregistry.azurecr.io/api-server:v2.1.0
    volumeMounts:
    - name: config
      mountPath: /app/config
```

**Sidecar Pattern (Kubernetes 1.28+ Native)**
```yaml
spec:
  containers:
  - name: app
    image: myapp:v1.0.0

  # Sidecar for log forwarding (restartPolicy: Always)
  initContainers:
  - name: log-forwarder
    image: fluent/fluent-bit:2.2
    restartPolicy: Always  # Native sidecar in K8s 1.28+
    volumeMounts:
    - name: logs
      mountPath: /var/log/app
```

## Integration with Related Skills

### Uses skill: **deployments**
- Deployment YAML specifications
- Rollout commands and operations
- Scaling operations
- Update strategies

### Works with skill: **helm**
- Chart templating for deployments
- Release management
- Values configuration
- Rollback procedures

### Coordinates with skill: **monitoring**
- Deployment health metrics
- Rollout monitoring
- Alert integration
- SLO tracking

### References skill: **gitops**
- ArgoCD application sync
- Flux reconciliation
- Progressive delivery integration
- Automated rollbacks

## When to Invoke This Agent

**Deployment Phase**
- Designing new application deployments
- Choosing deployment strategy
- Planning zero-downtime releases
- Setting up canary/blue-green

**Operations Phase**
- Scaling workloads
- Troubleshooting deployments
- Optimizing resource usage
- Managing rollouts/rollbacks

**Stateful Applications**
- Deploying databases
- Managing message queues
- Handling persistent data
- Cluster coordination

**Batch Processing**
- Setting up Jobs/CronJobs
- Data migration tasks
- Scheduled operations
- Parallel processing

## Success Criteria

| Metric | Target |
|--------|--------|
| Zero-downtime deployments | 99.99% |
| Rollback time | <30 seconds |
| Pod startup time | <60 seconds |
| HPA response time | <2 minutes |
| StatefulSet recovery | <5 minutes |
| Job completion rate | >99% |
| Resource utilization | 70-80% |
| PDB compliance | 100% |

## Troubleshooting Guide

### Decision Tree: Deployment Issues

```
Deployment not progressing?
|
+-- Check: kubectl rollout status deployment/name
    |
    +-- Stuck at "Waiting for rollout"
    |   |
    |   +-- Check pod status: kubectl get pods -l app=name
    |       |
    |       +-- Pending --> Node resources / scheduling
    |       +-- ImagePullBackOff --> Registry / credentials
    |       +-- CrashLoopBackOff --> Application / config
    |       +-- ContainerCreating --> Volume / network
    |
    +-- Rollback triggered?
        +-- Check: kubectl rollout history deployment/name
```

### Common Issues & Resolutions

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| Deployment stuck | Insufficient resources | Scale nodes / adjust requests |
| Pods CrashLoopBackOff | App crash / bad config | Check logs, fix config |
| ImagePullBackOff | Registry auth / image missing | Fix imagePullSecrets |
| StatefulSet not scaling | PVC provisioning failed | Check storage class |
| Job keeps failing | Bad exit code | Check backoffLimit, logs |
| HPA not scaling | Metrics unavailable | Install metrics-server |
| PDB blocking drain | Not enough replicas | Increase replicas |

### Debug Commands Cheatsheet

```bash
# Deployment status
kubectl rollout status deployment/name
kubectl rollout history deployment/name
kubectl rollout undo deployment/name --to-revision=2

# Pod debugging
kubectl describe pod pod-name
kubectl logs pod-name --previous
kubectl exec -it pod-name -- /bin/sh

# Events (sorted by time)
kubectl get events --sort-by='.lastTimestamp' | tail -20

# Resource usage
kubectl top pods
kubectl describe node | grep -A 5 "Allocated resources"

# StatefulSet specific
kubectl get pvc -l app=statefulset-name
kubectl delete pod statefulset-name-0  # Triggers recreation

# Job debugging
kubectl describe job job-name
kubectl logs job/job-name
```

## Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Slow rollouts | Increase maxSurge, optimize probes |
| Frequent rollbacks | Better testing, canary with analysis |
| StatefulSet data loss | Proper PVC retention, backup strategy |
| Job failures | Retry logic, idempotent operations |
| Resource contention | PDB, proper requests/limits, priority |
| Cascade failures | Circuit breakers, proper probe config |
| Config drift | GitOps, immutable deployments |
| Scaling delays | KEDA, predictive scaling, warm pools |
