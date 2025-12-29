---
name: quickstart
description: Get Started with Kubernetes
allowed-tools: Read
---

# /quickstart - Get Started with Kubernetes

Start your Kubernetes journey with fundamentals and best practices.

## What This Command Does

Provides:
- ✅ Kubernetes basics overview
- ✅ Local setup guide
- ✅ First deployment tutorial
- ✅ Core concepts explained
- ✅ Next steps recommendation

## Prerequisites

- Docker installed
- kubectl installed
- 4GB RAM minimum
- 20GB disk space

## Quick Setup

### Option 1: Kind (Kubernetes in Docker)
```bash
# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind

# Create cluster
./kind create cluster --name my-cluster

# Verify
kubectl cluster-info
kubectl get nodes
```

### Option 2: Minikube
```bash
# Install minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start cluster
minikube start --cpus=4 --memory=8192

# Verify
kubectl get nodes
```

### Option 3: Managed Service
- **AWS EKS**: Amazon Elastic Kubernetes Service
- **Google GKE**: Google Kubernetes Engine
- **Azure AKS**: Azure Kubernetes Service

## Your First Deployment

```bash
# Create namespace
kubectl create namespace tutorial

# Deploy nginx
kubectl run nginx --image=nginx:latest -n tutorial

# Expose service
kubectl expose pod nginx --port=80 --type=NodePort -n tutorial

# Check service
kubectl get svc -n tutorial

# Access application
# For kind/minikube:
kubectl port-forward -n tutorial svc/nginx 8080:80
# Then visit http://localhost:8080
```

## Core Concepts

### Kubernetes Objects
- **Pod**: Smallest deployable unit
- **Service**: Network access to pods
- **Deployment**: Manage pod replicas
- **ConfigMap**: Configuration storage
- **Secret**: Sensitive data storage

### Key Commands
```bash
# Get resources
kubectl get pods
kubectl get services
kubectl get deployments

# Describe resources
kubectl describe pod pod-name
kubectl describe service service-name

# View logs
kubectl logs pod-name
kubectl logs -f pod-name

# Execute in pod
kubectl exec -it pod-name -- /bin/bash
```

## Learning Path

1. **Fundamentals** (Week 1)
   - Kubernetes architecture
   - Objects and resources
   - Pods and containers
   - Basic deployments

2. **Intermediate** (Week 2-3)
   - Services and networking
   - ConfigMaps and Secrets
   - Storage and persistence
   - Multi-replica deployments

3. **Advanced** (Week 4+)
   - RBAC and security
   - Monitoring and logging
   - CI/CD integration
   - Production patterns

## Next Steps

- `/cluster-setup` - Learn production cluster setup
- `/best-practices` - Kubernetes best practices
- `/troubleshoot` - Debugging common issues

## Resources

- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [Interactive Tutorial](https://kubernetes.io/docs/tutorials/)
- [Kubernetes 101](https://www.digitalocean.com/community/tutorial_series/kubernetes-101)

---

Start exploring with: `kubectl get all --all-namespaces`
