# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_slurm role.

## Overview

This role sets up Slurm workload manager for high-performance computing and job scheduling across the cluster.

## Purpose

- Configure Slurm for job scheduling and resource management
- Set up compute nodes and controller
- Configure job queues and partitions
- Integrate with cluster storage and networking

## Files

- `tasks/main.yaml`: Main task file
- `templates/slurm.conf.j2`: Slurm configuration template
- `templates/cgroup.conf.j2`: Cgroup configuration template
- `templates/cgroup_allowed_devices_file.conf.j2`: Device access configuration

## Key Features

- Job scheduling and resource management
- Multi-node compute cluster setup
- Integration with NFS storage
- Cgroup resource management

## Dependencies

- Requires NFS storage for shared directories
- Uses cluster networking configuration
- Integrates with user management

## Variables

- `slurm.*`: Slurm configuration variables
- NFS paths and shared directories
- Node and partition configuration

## Usage

Typically called via the setup_slurm playbook:
```yaml
- { role: 'goldentooth.setup_slurm' }
```

## Integration

Works with NFS storage and cluster networking for distributed computing.