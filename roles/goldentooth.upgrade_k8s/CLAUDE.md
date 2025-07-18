# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.upgrade_k8s role.

## Overview

This role upgrades the Kubernetes cluster to a newer version using kubeadm upgrade procedures.

## Purpose

- Upgrade Kubernetes cluster version
- Update cluster components
- Maintain cluster availability during upgrade
- Ensure proper upgrade sequencing

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Kubernetes version upgrade using kubeadm
- Rolling upgrade of cluster components
- Maintenance of cluster availability
- Proper upgrade sequencing

## Dependencies

- Requires kubeadm to be installed
- Uses Kubernetes cluster configuration
- Requires appropriate permissions

## Variables

- `kubernetes_version`: Target Kubernetes version
- Upgrade configuration parameters
- Cluster component settings

## Usage

Typically called via the upgrade_k8s playbook:
```yaml
- { role: 'goldentooth.upgrade_k8s' }
```

## Security Considerations

- Critical operation requiring careful planning
- Test upgrades in non-production environments
- Ensure proper backups before upgrade