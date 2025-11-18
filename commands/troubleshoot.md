# /troubleshoot - Kubernetes Troubleshooting Guide

Diagnose and resolve common Kubernetes issues.

## Pod Issues

### Pod Stuck in Pending
```bash
# Check events
kubectl describe pod pod-name

# Common causes:
# 1. Insufficient resources
kubectl top nodes
kubectl describe node node-name

# 2. Image pull errors
kubectl logs pod-name --previous

# 3. PVC not bound
kubectl get pvc
kubectl describe pvc pvc-name
```

### CrashLoopBackOff
```bash
# Check logs
kubectl logs pod-name
kubectl logs pod-name --previous

# Check pod events
kubectl describe pod pod-name

# Common solutions:
# - Fix application configuration
# - Check resource limits
# - Verify image exists
```

### ImagePullBackOff
```bash
# Check image exists
docker pull image-name

# Verify registry credentials
kubectl get secrets

# Check image in pod spec
kubectl get pod pod-name -o yaml | grep image:
```

## Node Issues

### Node NotReady
```bash
# Check node status
kubectl get nodes
kubectl describe node node-name

# Check kubelet logs
ssh to-node
journalctl -u kubelet -n 50

# Common causes:
# - Disk pressure
# - Memory pressure
# - Network issues
# - kubelet crashed
```

### Node Unreachable
```bash
# Check node connectivity
ping node-ip

# Check node status
kubectl describe node node-name

# Solutions:
# - Restart kubelet: systemctl restart kubelet
# - Check firewall rules
# - Verify network connectivity
```

## Networking Issues

### Service Not Accessible
```bash
# Check service
kubectl get svc
kubectl describe svc service-name

# Check endpoints
kubectl get endpoints service-name
kubectl describe endpoints service-name

# Test connectivity
kubectl run debug --image=nicolaka/netshoot -it --rm -- /bin/bash
```

### DNS Resolution Issues
```bash
# Test DNS
kubectl run debug --image=nicolaka/netshoot -it --rm -- nslookup service-name

# Check CoreDNS
kubectl get pods -n kube-system | grep coredns
kubectl logs -n kube-system -l k8s-app=kube-dns

# Check resolv.conf
kubectl exec pod-name -- cat /etc/resolv.conf
```

### Network Policy Issues
```bash
# Check policies
kubectl get networkpolicies
kubectl describe networkpolicy policy-name

# Test connectivity
kubectl run debug --image=nicolaka/netshoot -it --rm -- /bin/bash
# Inside: nc -zv service-name 80

# Temporarily remove policy for testing
kubectl delete networkpolicy policy-name
```

## Storage Issues

### PVC Pending
```bash
# Check PVC
kubectl get pvc
kubectl describe pvc pvc-name

# Check storage class
kubectl get storageclass
kubectl describe storageclass storage-class-name

# Check PV
kubectl get pv
kubectl describe pv pv-name

# Solutions:
# - Create PV manually
# - Check provisioner status
```

### Volume Mount Failed
```bash
# Check pod events
kubectl describe pod pod-name

# Check volume
kubectl get pv
kubectl logs pod-name

# Solutions:
# - Verify PVC exists
# - Check storage provisioner
# - Verify node has access
```

## Resource Issues

### OOMKilled
```bash
# Check memory usage
kubectl top pod pod-name

# Increase memory limit
kubectl set resources deployment deployment-name \
  --limits=memory=1Gi \
  --requests=memory=512Mi

# Check events
kubectl describe pod pod-name | grep -i memory
```

### CPU Throttling
```bash
# Check CPU usage
kubectl top pod pod-name --containers

# Check requests/limits
kubectl get pod pod-name -o json | \
  jq '.spec.containers[].resources'

# Increase CPU limits
kubectl set resources deployment deployment-name \
  --limits=cpu=1000m \
  --requests=cpu=500m
```

## Debugging Tools

### Execute in Pod
```bash
# Bash
kubectl exec -it pod-name -- /bin/bash

# View environment
kubectl exec pod-name -- env

# Run single command
kubectl exec pod-name -- ls -la
```

### Debug Container
```bash
# Ephemeral debug container
kubectl debug pod-name -it --image=nicolaka/netshoot

# Or create debug pod
kubectl run -it --rm debug --image=nicolaka/netshoot -- bash
```

### Logs Analysis
```bash
# Follow logs
kubectl logs -f pod-name

# Previous container logs
kubectl logs pod-name --previous

# Multiple pods
kubectl logs -l app=myapp

# Timestamps
kubectl logs pod-name --timestamps=true

# Search logs
kubectl logs pod-name | grep ERROR
```

## Cluster Diagnostics

### Check Cluster Health
```bash
# Node status
kubectl get nodes

# Component status
kubectl get cs

# Key pods
kubectl get pods -n kube-system
```

### Collect Debug Info
```bash
# Cluster info
kubectl cluster-info dump --output-directory=./cluster-info

# Describe all resources
kubectl describe all --all-namespaces

# All events
kubectl get events --all-namespaces
```

## Common Solutions

| Issue | Solution |
|-------|----------|
| Pod won't start | Check logs, describe pod, check resources |
| Service not accessible | Verify service/endpoints, check network policies |
| Nodes failing | Check kubelet, disk space, memory |
| Storage not working | Check PVC/PV, storage provisioner |
| DNS not resolving | Check CoreDNS, resolv.conf |

---

Enable debug logging:
```bash
kubectl set env ds/kubelet -n kube-system --list
```
