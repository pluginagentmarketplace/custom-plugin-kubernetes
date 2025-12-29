---
name: cluster-admin
description: Master Kubernetes cluster administration, from initial setup through production management. Learn cluster installation, scaling, upgrades, and HA strategies.
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Cluster Administration

## Quick Start

### Create a Local Kubernetes Cluster
```bash
# Using kind (Kubernetes in Docker)
kind create cluster --name my-cluster

# Using minikube
minikube start --cpus=4 --memory=8192

# Verify cluster
kubectl cluster-info
kubectl get nodes
```

### Manage Cluster Access
```bash
# View kubeconfig
kubectl config view

# Set current context
kubectl config use-context my-cluster

# Create service account
kubectl create serviceaccount my-user
kubectl create rolebinding my-user-admin --clusterrole=admin --serviceaccount=default:my-user
```

## Core Concepts

### Cluster Architecture
- **Control Plane**: API server, scheduler, controller manager, etcd
- **Worker Nodes**: kubelet, kube-proxy, container runtime
- **Add-ons**: DNS, monitoring, logging, networking

### Node Management
```bash
# List nodes
kubectl get nodes -o wide

# Describe node
kubectl describe node node-name

# Drain node (before maintenance)
kubectl drain node-name --ignore-daemonsets

# Uncordon node
kubectl uncordon node-name

# Add labels to node
kubectl label nodes node-name disktype=ssd
```

### Scaling & Capacity
- Horizontal scaling (add nodes)
- Vertical scaling (increase node resources)
- Cluster autoscaling
- Resource quotas
- LimitRanges

### HA & Disaster Recovery
- Multi-master setup
- etcd backup and restore
- Leader election
- Health checks
- Self-healing

## Advanced Topics

### Cluster Upgrades
```bash
# Check current version
kubectl version

# Upgrade control plane (managed service)
# For EKS, AKS, GKE: use provider's upgrade process

# Upgrade worker nodes
kubectl cordon node
kubectl drain node
# Update kubelet binary
kubectl uncordon node
```

### Multi-Cluster Management
- Federation
- Cross-cluster networking
- Disaster recovery
- Load balancing across clusters

### Resource Planning
- CPU and memory requirements
- Storage capacity
- Network bandwidth
- Cost optimization

## Resources
- [Official Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes Cluster Administration](https://kubernetes.io/docs/tasks/administer-cluster/)
- [kubeadm Installation Guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
