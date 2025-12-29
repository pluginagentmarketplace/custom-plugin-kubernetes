---
name: docker-containers
description: Master Docker containerization, image building, optimization, and container registry management. Learn containerization best practices and image security.
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Docker & Containers

## Quick Start

### Build Your First Image
```dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

```bash
# Build image
docker build -t my-app:1.0 .

# Run container
docker run -p 3000:3000 my-app:1.0

# Check running containers
docker ps

# View logs
docker logs <container-id>
```

### Image Optimization
```dockerfile
# Multi-stage build (optimized)
FROM node:18 as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

## Core Concepts

### Dockerfile Best Practices
- **Layer Caching**: Order commands by change frequency
- **Minimal Base Images**: Use alpine or distroless
- **Multi-stage**: Separate build and runtime
- **Non-root User**: Security best practice
- **Health Checks**: Define health probes

### Image Registry
```bash
# Login to registry
docker login docker.io
docker login my-registry.azurecr.io

# Tag and push
docker tag my-app:1.0 my-registry/my-app:1.0
docker push my-registry/my-app:1.0

# Pull image
docker pull my-registry/my-app:1.0
```

### Container Runtime
- containerd
- CRI-O
- Docker runtime compatibility
- Runtime configuration

### Image Scanning
```bash
# Scan with Trivy
trivy image my-app:1.0

# Scan with Grype
grype my-app:1.0

# Fix vulnerabilities
# Update base image
# Rebuild and rescan
```

## Advanced Topics

### Image Layering
- Understanding layers
- Minimizing layers
- Layer compression
- Sharing common layers

### Security
- Non-root users
- Read-only filesystems
- Capability dropping
- Secrets management
- Image signing

### Performance
- Layer ordering
- Caching strategies
- Image size reduction
- Build optimization

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Container Security Best Practices](https://kubernetes.io/docs/concepts/security/)
