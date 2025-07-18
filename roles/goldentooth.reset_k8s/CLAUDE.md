# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.reset_k8s role.

## Overview

This role resets the Kubernetes cluster using kubeadm, removing all cluster configuration and state.

## Purpose

- Reset Kubernetes cluster state
- Remove cluster configuration
- Clean up cluster resources
- Prepare for cluster reinitialization

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Complete cluster reset using kubeadm
- Cleanup of cluster state and configuration
- Removal of cluster resources
- Preparation for fresh cluster setup

## Dependencies

- Requires kubeadm to be installed
- Uses Kubernetes cluster configuration
- Requires appropriate permissions

## Variables

- Kubernetes configuration variables
- Cluster reset parameters
- Cleanup configuration

## Usage

Typically called via the reset_k8s playbook:
```yaml
- { role: 'goldentooth.reset_k8s' }
```

## Security Considerations

- Destructive operation that removes all cluster data
- Use with caution in production environments
- Ensure proper backups before reset