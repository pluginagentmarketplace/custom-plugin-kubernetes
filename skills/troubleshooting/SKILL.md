---
name: troubleshooting
description: Kubernetes debugging, problem diagnosis, and issue resolution
sasmp_version: "1.3.0"
bonded_agent: 01-cluster-admin
bond_type: PRIMARY_BOND
---

# Kubernetes Troubleshooting Skill

## Overview
Master debugging and troubleshooting techniques for Kubernetes clusters, pods, networking, and applications.

## Topics Covered

### Pod Troubleshooting
- Pod status analysis
- Container logs examination
- CrashLoopBackOff resolution
- ImagePullBackOff fixes
- Resource constraint issues

### Debugging Tools
- kubectl debug usage
- Ephemeral containers
- kubectl exec for live debugging
- stern for multi-pod logs
- k9s terminal UI

### Networking Issues
- DNS resolution problems
- Service connectivity
- Network policy debugging
- Ingress troubleshooting
- CNI issues

### Cluster Problems
- Node health analysis
- Control plane debugging
- etcd issues
- Scheduler problems
- API server troubleshooting

### Common Patterns
- OOMKilled analysis
- Pending pods resolution
- Volume mount issues
- ConfigMap/Secret problems

## Prerequisites
- Kubernetes operations
- Linux fundamentals
- Networking basics

## Learning Outcomes
- Diagnose pod failures quickly
- Fix networking issues
- Debug cluster components
- Create troubleshooting runbooks
