# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_nfs_mounts role.

## Overview

This role configures NFS client mounts on cluster nodes for shared storage access across the cluster.

## Purpose

- Configure NFS client mounts
- Set up shared storage access
- Configure mount options and automation
- Integrate with cluster storage infrastructure

## Files

- `tasks/main.yaml`: Main task file
- `templates/mount.j2`: Mount configuration template
- `templates/automount.j2`: Automount configuration template

## Key Features

- NFS client mount configuration
- Automated mount management
- Shared storage access across cluster
- Mount option optimization

## Dependencies

- Requires NFS server to be configured
- Uses cluster storage configuration
- Integrates with filesystem management

## Variables

- `nfs.*`: NFS configuration variables
- Mount paths and options
- Server and share configuration

## Usage

Typically called via the setup_nfs_mounts playbook:
```yaml
- { role: 'goldentooth.setup_nfs_mounts' }
```

## Integration

Works with NFS server and cluster storage for shared filesystem access.