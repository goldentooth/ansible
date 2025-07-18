# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.uninstall_k8s_packages role.

## Overview

This role removes Kubernetes packages from cluster nodes, typically used for cleanup or major version changes.

## Purpose

- Remove Kubernetes packages from nodes
- Clean up Kubernetes installation
- Prepare for fresh Kubernetes installation
- Remove package dependencies

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Removal of Kubernetes packages
- Cleanup of package dependencies
- System preparation for reinstallation
- Complete package removal

## Dependencies

- Requires package management system
- Uses Kubernetes package configuration
- Requires appropriate permissions

## Variables

- `kubernetes.apt_packages`: Kubernetes packages to remove
- Package management configuration
- Cleanup parameters

## Usage

Typically called via the uninstall_k8s_packages playbook:
```yaml
- { role: 'goldentooth.uninstall_k8s_packages' }
```

## Security Considerations

- Destructive operation that removes Kubernetes
- Use with caution in production environments
- Ensure proper backups and planning