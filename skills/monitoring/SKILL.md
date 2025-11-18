---
name: monitoring
description: Master Kubernetes observability, monitoring with Prometheus, logging, metrics, and distributed tracing. Learn to implement comprehensive monitoring strategies.
---

# Kubernetes Monitoring & Observability

## Quick Start

### Install Prometheus Stack
```bash
# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace
```

### Basic Prometheus Queries
```promql
# CPU usage by pod
sum(rate(container_cpu_usage_seconds_total[5m])) by (pod_name)

# Memory usage
sum(container_memory_usage_bytes) by (pod_name)

# Request rate
sum(rate(http_request_duration_seconds_count[5m]))
```

### Enable Container Logs
```bash
# View pod logs
kubectl logs pod-name

# Follow logs
kubectl logs -f pod-name

# Logs from specific container
kubectl logs pod-name -c container-name

# Previous crashed container logs
kubectl logs pod-name --previous
```

## Core Concepts

### Metrics Collection
- **Prometheus**: Metrics collection and storage
- **node-exporter**: Host metrics
- **kube-state-metrics**: Kubernetes resource metrics
- **cAdvisor**: Container metrics

### Grafana Dashboards
```bash
# Access Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Default credentials
# Username: admin
# Password: prom-operator
```

### Logging Stack
- **Fluentd/Logstash**: Log collection
- **Elasticsearch**: Log storage
- **Kibana**: Log visualization

### Key Metrics
- Pod CPU and memory usage
- Node resource availability
- API server latency
- Etcd performance
- Container restart count

## Advanced Topics

### Distributed Tracing
```bash
# Install Jaeger
helm install jaeger jaegertracing/jaeger -n tracing --create-namespace

# Configure application tracing
# Use OpenTelemetry SDK
```

### Custom Metrics
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
    - job_name: 'kubernetes-pods'
      kubernetes_sd_configs:
      - role: pod
```

### AlertManager
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-config
data:
  config.yml: |
    route:
      receiver: 'default'
    receivers:
    - name: 'default'
      slack_configs:
      - api_url: 'YOUR_SLACK_WEBHOOK_URL'
```

## Resources
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Kubernetes Monitoring](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)
