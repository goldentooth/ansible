# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.bootstrap_k8s role.

## Overview

This role bootstraps a Kubernetes cluster using kubeadm, configuring control plane nodes and setting up cluster networking with Calico.

## Purpose

- Initialize Kubernetes control plane with kubeadm
- Configure additional control plane nodes
- Set up Calico networking
- Configure kubectl access
- Install cluster networking components

## Files

- `tasks/main.yaml`: Main task file
- `templates/kubeadm-controlplane.yaml.j2`: kubeadm configuration template

## Key Features

### Multi-Control Plane Setup
- Initializes first control plane node
- Joins additional control plane nodes
- Configures HA control plane with load balancer

### Networking Configuration
- Installs Calico CNI for pod networking
- Configures pod and service CIDR ranges
- Sets up network policies

### Certificate Management
- Manages Kubernetes PKI certificates
- Integrates with cluster certificate authority
- Configures secure communication

### Load Balancer Integration
- Configures control plane behind HAProxy
- Uses load balancer for API server access
- Ensures HA for cluster API

## Dependencies

- Requires kubeadm, kubectl, kubelet to be installed
- Depends on HAProxy load balancer configuration
- Requires proper network configuration
- Uses containerd as container runtime

## Variables

Key variables from inventory:
- `kubernetes.first`: First control plane node
- `kubernetes.rest`: Additional control plane nodes
- `haproxy.domain_name`: Load balancer domain
- `network.pod.cidr`: Pod network CIDR
- `network.service.cidr`: Service network CIDR

## Usage

This role is typically called via the bootstrap_k8s playbook:
```yaml
- { role: 'goldentooth.bootstrap_k8s' }
```

## Integration

Works with:
- `goldentooth.setup_haproxy`: Load balancer setup
- `goldentooth.install_helm`: Helm installation
- `goldentooth.install_argo_cd`: GitOps setup
- containerd container runtime

## Security Considerations

- Secure control plane communication
- RBAC configured for cluster access
- Network policies for pod security
- Certificate-based authentication
- Secure etcd configuration