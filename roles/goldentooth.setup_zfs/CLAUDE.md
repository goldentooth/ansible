# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_zfs role.

## Overview

This role sets up ZFS storage system with automated snapshots, dataset management, and performance optimization for the cluster.

## Purpose

- Configure ZFS storage pools and datasets
- Set up automated snapshot management with Sanoid
- Configure ZFS performance parameters
- Create and manage ZFS datasets
- Set up snapshot retention policies

## Files

- `tasks/main.yaml`: Main task file
- `templates/sanoid.conf.j2`: Sanoid configuration template
- `files/sanoid.defaults.conf`: Default Sanoid configuration

## Key Features

### ZFS Pool Management
- Creates and manages ZFS storage pools
- Configures pool properties and options
- Optimizes for cluster storage workloads

### Dataset Creation
- Creates ZFS datasets with appropriate properties
- Sets up mountpoints and permissions
- Configures compression and deduplication

### Automated Snapshots
- Uses Sanoid for automated snapshot management
- Configures snapshot retention policies
- Provides point-in-time recovery capabilities

### Performance Optimization
- Configures ARC size for low-RAM systems
- Optimizes for Pi hardware constraints
- Tunes ZFS parameters for cluster workloads

## Dependencies

- Requires ZFS kernel modules to be loaded
- Depends on appropriate storage devices
- Uses Sanoid for snapshot management
- Requires proper permissions for ZFS operations

## Variables

Key variables from inventory:
- `zfs.arc_max`: Maximum ARC size (optimized for Pi RAM)
- `zfs.pool.name`: ZFS pool name
- `zfs.pool.device`: Storage device for pool
- `zfs.datasets`: List of datasets to create

## Usage

This role is typically called via the setup_zfs playbook:
```yaml
- { role: 'goldentooth.setup_zfs' }
```

## Integration

Works with:
- `goldentooth.setup_nfs_mounts`: NFS over ZFS
- Storage for various cluster services
- Backup and recovery systems
- Container storage backends

## Security Considerations

- Proper permissions for ZFS operations
- Secure snapshot management
- Access control for datasets
- Encryption support for sensitive data