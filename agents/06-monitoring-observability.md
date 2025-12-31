---
name: 06-monitoring-observability
description: Specialist in observability, monitoring, logging, metrics, and distributed tracing. Expert in implementing comprehensive monitoring strategies, SLO-based alerting, and production troubleshooting at enterprise scale.
model: sonnet
tools: All tools
sasmp_version: "1.3.0"
eqhm_enabled: true
skills:
  - monitoring
triggers:
  - "kubernetes monitoring"
  - "kubernetes"
  - "k8s"
capabilities: ["Prometheus & metrics collection", "Grafana dashboards & visualization", "Logging with Loki/ELK/Fluentd", "Distributed tracing with OpenTelemetry", "SLO-based alerting & AlertManager", "Cost-effective observability", "AIOps & anomaly detection", "Production debugging"]
---

# Monitoring & Observability

## Executive Summary
Enterprise-grade Kubernetes observability architecture implementing the three pillars of observability: metrics, logs, and traces. This agent provides deep expertise in building cost-effective, scalable monitoring solutions with SLO-based alerting, actionable dashboards, and production-ready troubleshooting capabilities.

## Core Competencies

### 1. Observability Architecture

**Three Pillars of Observability**
```
                    ┌─────────────────────────────────────┐
                    │         User Experience             │
                    │      (SLIs, SLOs, Error Budgets)    │
                    └─────────────────────────────────────┘
                                    ↑
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
   ┌────┴────┐               ┌──────┴──────┐             ┌──────┴──────┐
   │ METRICS │               │    LOGS     │             │   TRACES    │
   │Prometheus│               │  Loki/ELK  │             │OpenTelemetry│
   └────┬────┘               └──────┬──────┘             └──────┬──────┘
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    ↓
                    ┌─────────────────────────────────────┐
                    │       Kubernetes Workloads          │
                    └─────────────────────────────────────┘
```

**Observability Stack Comparison**

| Stack | Metrics | Logs | Traces | Cost | Complexity |
|-------|---------|------|--------|------|------------|
| **Prometheus + Loki + Tempo** | Native | Efficient | Integrated | Low | Medium |
| **Datadog** | SaaS | SaaS | SaaS | High | Low |
| **ELK + Jaeger** | Via exporter | Powerful | Good | Medium | High |
| **Grafana Cloud** | Managed | Managed | Managed | Medium | Low |

### 2. Prometheus & Metrics

**Production Prometheus Stack**
```yaml
# kube-prometheus-stack values
prometheus:
  prometheusSpec:
    retention: 30d
    retentionSize: 100GB
    resources:
      requests:
        memory: 4Gi
        cpu: 2
      limits:
        memory: 8Gi
        cpu: 4
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: fast-ssd
          resources:
            requests:
              storage: 200Gi
    # Remote write for long-term storage
    remoteWrite:
    - url: https://prometheus-remote-write.example.com/api/v1/write
      writeRelabelConfigs:
      - sourceLabels: [__name__]
        regex: 'up|container_.*|kube_.*|node_.*'
        action: keep
    # Service discovery
    serviceMonitorSelector:
      matchLabels:
        release: prometheus

alertmanager:
  alertmanagerSpec:
    resources:
      requests:
        memory: 256Mi
        cpu: 100m
```

**ServiceMonitor for Application**
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: api-server
  labels:
    release: prometheus
spec:
  selector:
    matchLabels:
      app: api-server
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
    scrapeTimeout: 10s
    relabelings:
    - sourceLabels: [__meta_kubernetes_pod_label_version]
      targetLabel: version
    metricRelabelings:
    - sourceLabels: [__name__]
      regex: 'go_.*'
      action: drop  # Drop high-cardinality metrics
  namespaceSelector:
    matchNames:
    - production
```

**Essential PromQL Queries**
```promql
# Request rate (RED method - Rate)
sum(rate(http_requests_total{job="api-server"}[5m])) by (service)

# Error rate (RED method - Errors)
sum(rate(http_requests_total{job="api-server",status=~"5.."}[5m]))
  / sum(rate(http_requests_total{job="api-server"}[5m])) * 100

# Latency p99 (RED method - Duration)
histogram_quantile(0.99,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le, service)
)

# Container CPU usage
sum(rate(container_cpu_usage_seconds_total{namespace="production"}[5m]))
  by (pod)

# Container memory usage percentage
sum(container_memory_working_set_bytes{namespace="production"}) by (pod)
  / sum(container_spec_memory_limit_bytes{namespace="production"}) by (pod) * 100

# Pod restart rate
sum(increase(kube_pod_container_status_restarts_total[1h])) by (namespace, pod)

# Node CPU pressure
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### 3. Logging Architecture

**Loki Stack Configuration**
```yaml
# Loki Helm values
loki:
  auth_enabled: false
  commonConfig:
    replication_factor: 3
  storage:
    bucketNames:
      chunks: loki-chunks
      ruler: loki-ruler
    type: s3
    s3:
      endpoint: s3.amazonaws.com
      region: us-east-1
      bucketnames: loki-data
      access_key_id: ${AWS_ACCESS_KEY_ID}
      secret_access_key: ${AWS_SECRET_ACCESS_KEY}
  limits_config:
    retention_period: 720h  # 30 days
    max_query_lookback: 720h
    ingestion_rate_mb: 10
    ingestion_burst_size_mb: 20
    max_entries_limit_per_query: 5000

promtail:
  config:
    clients:
    - url: http://loki-gateway/loki/api/v1/push
    snippets:
      pipelineStages:
      - cri: {}
      - multiline:
          firstline: '^\d{4}-\d{2}-\d{2}'
      - json:
          expressions:
            level: level
            message: msg
      - labels:
          level:
```

**Fluent Bit for Log Forwarding**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: logging
data:
  fluent-bit.conf: |
    [SERVICE]
        Flush         5
        Daemon        Off
        Log_Level     info
        Parsers_File  parsers.conf

    [INPUT]
        Name              tail
        Path              /var/log/containers/*.log
        Parser            cri
        Tag               kube.*
        Mem_Buf_Limit     50MB
        Skip_Long_Lines   On
        Refresh_Interval  10

    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        Merge_Log           On
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On

    [OUTPUT]
        Name            loki
        Match           kube.*
        Host            loki-gateway.logging.svc
        Port            80
        Labels          job=fluent-bit, namespace=$kubernetes['namespace_name']
```

**LogQL Queries**
```logql
# Error logs from production
{namespace="production"} |= "error" | json | level="error"

# Slow requests (>1s)
{namespace="production", app="api-server"}
  | json
  | duration > 1s

# Top 10 error messages
topk(10, sum by (message) (rate({namespace="production"} |= "error" [5m])))

# Log volume by namespace
sum by (namespace) (rate({job="fluent-bit"}[5m]))
```

### 4. Distributed Tracing

**OpenTelemetry Collector**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
data:
  config.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318

    processors:
      batch:
        timeout: 5s
        send_batch_size: 1000
      memory_limiter:
        check_interval: 1s
        limit_mib: 1000
        spike_limit_mib: 200
      resource:
        attributes:
        - key: environment
          value: production
          action: upsert

    exporters:
      otlp:
        endpoint: tempo-distributor:4317
        tls:
          insecure: true
      prometheus:
        endpoint: 0.0.0.0:8889

    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch, resource]
          exporters: [otlp]
        metrics:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [prometheus]
```

**Application Instrumentation (Python)**
```python
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Configure tracer
provider = TracerProvider()
processor = BatchSpanProcessor(
    OTLPSpanExporter(endpoint="otel-collector:4317", insecure=True)
)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

# Auto-instrument frameworks
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()

# Manual instrumentation
tracer = trace.get_tracer(__name__)

@app.route('/api/orders')
def create_order():
    with tracer.start_as_current_span("create_order") as span:
        span.set_attribute("order.type", "standard")
        # Business logic
        return {"status": "created"}
```

### 5. SLO-Based Alerting

**SLO Definition**
```yaml
# Sloth SLO definition
apiVersion: sloth.slok.dev/v1
kind: PrometheusServiceLevel
metadata:
  name: api-server-slo
  namespace: production
spec:
  service: api-server
  labels:
    team: platform
    tier: critical
  slos:
  - name: availability
    objective: 99.9
    description: "API availability SLO"
    sli:
      events:
        errorQuery: sum(rate(http_requests_total{job="api-server",status=~"5.."}[{{.window}}]))
        totalQuery: sum(rate(http_requests_total{job="api-server"}[{{.window}}]))
    alerting:
      name: APIServerHighErrorRate
      labels:
        severity: critical
      annotations:
        summary: "API Server error rate exceeds SLO"
      pageAlert:
        labels:
          severity: critical
      ticketAlert:
        labels:
          severity: warning

  - name: latency
    objective: 99.0
    description: "API latency SLO (p99 < 500ms)"
    sli:
      events:
        errorQuery: |
          sum(rate(http_request_duration_seconds_bucket{job="api-server",le="0.5"}[{{.window}}]))
        totalQuery: sum(rate(http_request_duration_seconds_count{job="api-server"}[{{.window}}]))
```

**AlertManager Configuration**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-config
data:
  alertmanager.yml: |
    global:
      resolve_timeout: 5m
      slack_api_url: 'https://hooks.slack.com/services/xxx'
      pagerduty_url: 'https://events.pagerduty.com/v2/enqueue'

    route:
      receiver: 'default'
      group_by: ['alertname', 'namespace', 'severity']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 4h
      routes:
      - match:
          severity: critical
        receiver: 'pagerduty-critical'
        continue: true
      - match:
          severity: warning
        receiver: 'slack-warnings'

    receivers:
    - name: 'default'
      slack_configs:
      - channel: '#alerts-default'
        send_resolved: true

    - name: 'pagerduty-critical'
      pagerduty_configs:
      - service_key: '<pagerduty-service-key>'
        severity: critical
        description: '{{ .CommonAnnotations.summary }}'

    - name: 'slack-warnings'
      slack_configs:
      - channel: '#alerts-warnings'
        send_resolved: true
        title: '{{ .Status | toUpper }}: {{ .CommonLabels.alertname }}'
        text: '{{ .CommonAnnotations.description }}'

    inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match:
        severity: 'warning'
      equal: ['alertname', 'namespace']
```

### 6. Grafana Dashboards

**Dashboard as Code (Grafonnet)**
```jsonnet
local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

dashboard.new(
  'Kubernetes Workload Overview',
  tags=['kubernetes', 'workload'],
  time_from='now-1h',
  refresh='30s',
)
.addPanel(
  graphPanel.new(
    'Request Rate',
    datasource='Prometheus',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(http_requests_total{namespace="$namespace"}[5m])) by (service)',
      legendFormat='{{service}}',
    )
  ),
  gridPos={x: 0, y: 0, w: 12, h: 8},
)
.addPanel(
  graphPanel.new(
    'Error Rate',
    datasource='Prometheus',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(http_requests_total{namespace="$namespace",status=~"5.."}[5m])) by (service) / sum(rate(http_requests_total{namespace="$namespace"}[5m])) by (service) * 100',
      legendFormat='{{service}}',
    )
  ),
  gridPos={x: 12, y: 0, w: 12, h: 8},
)
```

### 7. Cost-Effective Observability

**Cardinality Management**
```yaml
# Prometheus recording rules for pre-aggregation
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: recording-rules
spec:
  groups:
  - name: aggregation
    interval: 1m
    rules:
    # Pre-aggregate high-cardinality metrics
    - record: namespace:http_requests:rate5m
      expr: sum(rate(http_requests_total[5m])) by (namespace)

    - record: namespace:container_cpu:rate5m
      expr: sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace)

    - record: namespace:container_memory:sum
      expr: sum(container_memory_working_set_bytes) by (namespace)
```

**Retention Strategy**
```yaml
# Multi-tier retention
prometheus:
  # Hot tier: 15 days, full resolution
  retention: 15d

# Remote write to Thanos for cold storage
remoteWrite:
- url: http://thanos-receive:19291/api/v1/receive
  writeRelabelConfigs:
  # Only send important metrics to long-term storage
  - sourceLabels: [__name__]
    regex: 'up|http_requests_total|container_cpu_usage_seconds_total|container_memory_working_set_bytes'
    action: keep
```

## Integration with Related Skills

### Uses skill: **monitoring**
- Prometheus configuration
- Grafana dashboards
- Alert rules
- Log queries

### Works with skill: **cluster-admin**
- Cluster health metrics
- Node monitoring
- Control plane observability
- Resource capacity

### Coordinates with skill: **deployments**
- Deployment metrics
- Rollout monitoring
- Canary analysis
- SLO tracking

### References skill: **troubleshooting**
- Debug procedures
- Log analysis
- Trace investigation
- Performance profiling

## When to Invoke This Agent

**Setup Phase**
- Designing observability architecture
- Deploying monitoring stack
- Creating dashboards
- Configuring alerts

**Operations Phase**
- Incident investigation
- Performance analysis
- Capacity planning
- Cost optimization

**SRE Practices**
- SLO definition
- Error budget tracking
- Postmortem analysis
- Chaos engineering

## Success Criteria

| Metric | Target |
|--------|--------|
| Metric collection uptime | 99.99% |
| Alert latency (fire → notify) | <2 minutes |
| Dashboard load time | <3 seconds |
| Log ingestion lag | <30 seconds |
| Trace sampling rate | 1% production |
| MTTD (Mean Time to Detect) | <5 minutes |
| Alert noise ratio | <10% false positive |
| Observability cost | <5% of infra |

## Troubleshooting Guide

### Decision Tree: High Latency Investigation

```
Latency spike detected?
|
+-- Check: Is it all services or specific?
    |
    +-- All services
    |   |
    |   +-- Check node CPU/memory (kubectl top nodes)
    |   +-- Check network (CNI health, packet drops)
    |   +-- Check control plane (API server latency)
    |
    +-- Specific service
        |
        +-- Check traces (distributed tracing)
        |   |
        |   +-- External dependency slow?
        |   +-- Database queries slow?
        |   +-- Internal processing slow?
        |
        +-- Check logs for errors
        +-- Check resource limits (CPU throttling)
        +-- Check HPA scaling events
```

### Common Issues & Resolutions

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| Missing metrics | ServiceMonitor not matched | Check labels, selector |
| High cardinality | Unbounded labels | Add relabeling, drop metrics |
| Prometheus OOM | Too many series | Reduce retention, add remote write |
| Alert not firing | Wrong threshold/query | Validate PromQL |
| Log gaps | Promtail backpressure | Scale Loki, add buffer |
| Trace sampling | Head sampling too low | Use adaptive sampling |
| Dashboard slow | Heavy queries | Use recording rules |

### Debug Commands Cheatsheet

```bash
# Prometheus targets
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Visit http://localhost:9090/targets

# Check Prometheus TSDB stats
curl -s localhost:9090/api/v1/status/tsdb | jq

# Validate PromQL
promtool test rules rules.yaml

# Check AlertManager status
kubectl port-forward -n monitoring svc/alertmanager 9093:9093

# Query Loki
logcli query '{namespace="production"}' --limit=100

# Validate recording rules
kubectl get prometheusrule -A

# Check OpenTelemetry collector
kubectl logs -n observability -l app=otel-collector
```

## Common Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Alert fatigue | SLO-based alerting, tuning |
| Metric explosion | Cardinality limits, relabeling |
| Log costs | Sampling, retention tiers |
| Trace overhead | Tail-based sampling |
| Dashboard sprawl | Golden signal dashboards |
| Tool proliferation | Unified stack (Grafana) |
| Compliance logging | Immutable storage, audit |
| Multi-cluster | Centralized Thanos/Cortex |
