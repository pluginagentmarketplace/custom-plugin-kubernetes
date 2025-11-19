# /cluster-setup - Production Cluster Setup

Complete guide to setting up production-grade Kubernetes clusters.

## Cluster Installation Options

### 1. Managed Services (Recommended for Start)

#### AWS EKS
```bash
# Create cluster using eksctl
eksctl create cluster --name production --region us-east-1 --nodes=3

# Add worker nodes
eksctl create nodegroup --cluster production --name workers

# Get kubeconfig
aws eks update-kubeconfig --region us-east-1 --name production
```

#### Google GKE
```bash
# Create cluster
gcloud container clusters create production \
  --zone us-central1-a \
  --num-nodes 3 \
  --machine-type n1-standard-2

# Get credentials
gcloud container clusters get-credentials production --zone us-central1-a
```

#### Azure AKS
```bash
# Create resource group
az group create --name myResourceGroup --location eastus

# Create cluster
az aks create --resource-group myResourceGroup \
  --name production \
  --node-count 3 \
  --vm-set-type VirtualMachineScaleSets

# Get credentials
az aks get-credentials --resource-group myResourceGroup --name production
```

### 2. Self-Hosted (kubeadm)

```bash
# Prerequisites: 3+ nodes with Ubuntu/CentOS

# On all nodes:
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# On master node:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install networking (Flannel):
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# On worker nodes:
kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

## Essential Components

### Container Runtime
```bash
# Install containerd (recommended)
wget https://github.com/containerd/containerd/releases/download/v1.6.0/containerd-1.6.0-linux-amd64.tar.gz
sudo tar Czxvf containerd-1.6.0-linux-amd64.tar.gz -C /
```

### Network Plugin
- Flannel: Simple, easy setup
- Calico: Advanced networking, security
- Weave: Encrypted networking
- Cilium: eBPF-based, high performance

### Storage
```bash
# Install local storage provisioner
helm install local-path local-path-provisioner/local-path-provisioner \
  --namespace local-path-storage --create-namespace
```

### Monitoring
```bash
# Install Prometheus stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace
```

## Security Hardening

### Network Policies
```bash
# Apply default deny policy
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

### RBAC Setup
```bash
# Create admin user
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl create clusterrolebinding admin-user \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:admin-user
```

### Pod Security
```bash
# Enable Pod Security Standards
kubectl label namespace default \
  pod-security.kubernetes.io/enforce=restricted
```

## Post-Installation

### Verify Cluster
```bash
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get svc --all-namespaces
```

### Configure kubectl
```bash
# Multiple clusters
kubectl config set-context prod --cluster=production --user=admin
kubectl config use-context prod
```

### High Availability
- Multi-master setup
- Load balance control plane
- Backup etcd regularly
- Monitor cluster health

## Next Steps

- `/best-practices` - Production best practices
- `/troubleshoot` - Troubleshooting guide
- `/quickstart` - Quick reference

---

Verify your cluster setup with: `kubectl cluster-info`
