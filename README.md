<div align="center">

<!-- Animated Typing Banner -->
<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&duration=3000&pause=1000&color=2E9EF7&center=true&vCenter=true&multiline=true&repeat=true&width=600&height=100&lines=Kubernetes+Assistant;8+Agents+%7C+12+Skills;Claude+Code+Plugin" alt="Kubernetes Assistant" />

<br/>

<!-- Badge Row 1: Status Badges -->
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)](https://github.com/pluginagentmarketplace/custom-plugin-kubernetes/releases)
[![License](https://img.shields.io/badge/License-Custom-yellow?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production-brightgreen?style=for-the-badge)](#)
[![SASMP](https://img.shields.io/badge/SASMP-v1.3.0-blueviolet?style=for-the-badge)](#)

<!-- Badge Row 2: Content Badges -->
[![Agents](https://img.shields.io/badge/Agents-8-orange?style=flat-square&logo=robot)](#-agents)
[![Skills](https://img.shields.io/badge/Skills-12-purple?style=flat-square&logo=lightning)](#-skills)
[![Commands](https://img.shields.io/badge/Commands-4-green?style=flat-square&logo=terminal)](#-commands)

<br/>

<!-- Quick CTA Row -->
[📦 **Install Now**](#-quick-start) · [🤖 **Explore Agents**](#-agents) · [📖 **Documentation**](#-documentation) · [⭐ **Star this repo**](https://github.com/pluginagentmarketplace/custom-plugin-kubernetes)

---

### What is this?

> **Kubernetes Assistant** is a Claude Code plugin with **8 agents** and **12 skills** for kubernetes development.

</div>

---

## 📑 Table of Contents

<details>
<summary>Click to expand</summary>

- [Quick Start](#-quick-start)
- [Features](#-features)
- [Agents](#-agents)
- [Skills](#-skills)
- [Commands](#-commands)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

</details>

---

## 🚀 Quick Start

### Prerequisites

- Claude Code CLI v2.0.27+
- Active Claude subscription

### Installation (Choose One)

<details open>
<summary><strong>Option 1: From Marketplace (Recommended)</strong></summary>

```bash
# Step 1️⃣ Add the marketplace
/plugin marketplace add pluginagentmarketplace/custom-plugin-kubernetes

# Step 2️⃣ Install the plugin
/plugin install kubernetes-assistant@pluginagentmarketplace-kubernetes

# Step 3️⃣ Restart Claude Code
# Close and reopen your terminal/IDE
```

</details>

<details>
<summary><strong>Option 2: Local Installation</strong></summary>

```bash
# Clone the repository
git clone https://github.com/pluginagentmarketplace/custom-plugin-kubernetes.git
cd custom-plugin-kubernetes

# Load locally
/plugin load .

# Restart Claude Code
```

</details>

### ✅ Verify Installation

After restart, you should see these agents:

```
kubernetes-assistant:06-monitoring-observability
kubernetes-assistant:01-cluster-admin
kubernetes-assistant:03-deployment-orchestration
kubernetes-assistant:05-security-rbac
kubernetes-assistant:04-storage-networking
... and 2 more
```

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **8 Agents** | Specialized AI agents for kubernetes tasks |
| 🛠️ **12 Skills** | Reusable capabilities with Golden Format |
| ⌨️ **4 Commands** | Quick slash commands |
| 🔄 **SASMP v1.3.0** | Full protocol compliance |

---

## 🤖 Agents

### 8 Specialized Agents

| # | Agent | Purpose |
|---|-------|---------|
| 1 | **06-monitoring-observability** | Specialist in observability, monitoring, logging, metrics, a |
| 2 | **01-cluster-admin** | Expert in Kubernetes cluster setup, management, architecture |
| 3 | **03-deployment-orchestration** | Expert in Kubernetes deployments, StatefulSets, DaemonSets,  |
| 4 | **05-security-rbac** | Expert in Kubernetes security, RBAC, network policies, and c |
| 5 | **04-storage-networking** | Specialist in persistent storage, networking, service mesh,  |
| 6 | **07-development-gitops** | Expert in development workflows, CI/CD integration, Helm, an |
| 7 | **02-container-runtime** | Specialist in Docker, container runtimes, image management,  |

---

## 🛠️ Skills

### Available Skills

| Skill | Description | Invoke |
|-------|-------------|--------|
| `security` | Master Kubernetes security, RBAC, network policies, pod secu | `Skill("kubernetes-assistant:security")` |
| `storage-networking` | Master Kubernetes storage management and networking architec | `Skill("kubernetes-assistant:storage-networking")` |
| `gitops` | Master GitOps practices, CI/CD integration, Helm charts, Kus | `Skill("kubernetes-assistant:gitops")` |
| `monitoring` | Master Kubernetes observability, monitoring with Prometheus, | `Skill("kubernetes-assistant:monitoring")` |
| `docker-containers` | Master Docker containerization, image building, optimization | `Skill("kubernetes-assistant:docker-containers")` |
| `cluster-admin` | Master Kubernetes cluster administration, from initial setup | `Skill("kubernetes-assistant:cluster-admin")` |
| `deployments` | Master Kubernetes Deployments, StatefulSets, DaemonSets, and | `Skill("kubernetes-assistant:deployments")` |

---

## ⌨️ Commands

| Command | Description |
|---------|-------------|
| `/troubleshoot` | Kubernetes Troubleshooting Guide |
| `/best-practices` | practices - Kubernetes Best Practices |
| `/quickstart` | Get Started with Kubernetes |
| `/cluster-setup` | setup - Production Cluster Setup |

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute |
| [LICENSE](LICENSE) | License information |

---

## 📁 Project Structure

<details>
<summary>Click to expand</summary>

```
custom-plugin-kubernetes/
├── 📁 .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── 📁 agents/              # 8 agents
├── 📁 skills/              # 12 skills (Golden Format)
├── 📁 commands/            # 4 commands
├── 📁 hooks/
├── 📄 README.md
├── 📄 CHANGELOG.md
└── 📄 LICENSE
```

</details>

---

## 📅 Metadata

| Field | Value |
|-------|-------|
| **Version** | 1.0.0 |
| **Last Updated** | 2025-12-29 |
| **Status** | Production Ready |
| **SASMP** | v1.3.0 |
| **Agents** | 8 |
| **Skills** | 12 |
| **Commands** | 4 |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md).

1. Fork the repository
2. Create your feature branch
3. Follow the Golden Format for new skills
4. Submit a pull request

---

## ⚠️ Security

> **Important:** This repository contains third-party code and dependencies.
>
> - ✅ Always review code before using in production
> - ✅ Check dependencies for known vulnerabilities
> - ✅ Follow security best practices
> - ✅ Report security issues privately via [Issues](../../issues)

---

## 📝 License

Copyright © 2025 **Dr. Umit Kacar** & **Muhsin Elcicek**

Custom License - See [LICENSE](LICENSE) for details.

---

## 👥 Contributors

<table>
<tr>
<td align="center">
<strong>Dr. Umit Kacar</strong><br/>
Senior AI Researcher & Engineer
</td>
<td align="center">
<strong>Muhsin Elcicek</strong><br/>
Senior Software Architect
</td>
</tr>
</table>

---

<div align="center">

**Made with ❤️ for the Claude Code Community**

[![GitHub](https://img.shields.io/badge/GitHub-pluginagentmarketplace-black?style=for-the-badge&logo=github)](https://github.com/pluginagentmarketplace)

</div>
