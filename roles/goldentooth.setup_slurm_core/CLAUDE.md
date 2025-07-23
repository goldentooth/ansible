# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_slurm_core role.

## Overview

This role sets up the core Slurm workload manager configuration - MUNGE authentication, basic Slurm installation, and essential configuration files. This is the FAST, lightweight version that focuses only on getting Slurm operational.

## Purpose

- Install and configure MUNGE authentication service
- Install Slurm workload manager packages
- Deploy core Slurm configuration files (slurm.conf, cgroup.conf)
- Create necessary directories (both NFS shared and local)
- Start and enable essential services
- Verify basic cluster functionality

## Key Features

- **Fast execution** - only essential Slurm components
- **Idempotent** - safe to run multiple times
- **Service management** - proper systemd service handling
- **Configuration validation** - checks cluster status after setup
- **Role separation** - controllers vs compute nodes handled appropriately

## Files

- `tasks/main.yaml`: Core Slurm setup tasks
- `templates/`: Slurm configuration templates (shared with original role)
- `handlers/main.yaml`: Service restart and MUNGE key synchronization handlers

## Dependencies

- Requires NFS storage mounted for shared directories
- Uses cluster networking configuration
- Depends on inventory groups: `slurm_controller`, `slurm_compute`

## Variables

- `slurm.*`: Slurm configuration variables from inventory
- `slurm.shared_directories`: NFS directories to create
- `slurm.local_directories`: Local directories to create

## Usage

Fast Slurm core setup:
```bash
goldentooth setup_slurm_core
```

This role should be run BEFORE:
- `goldentooth.setup_lmod` (if using environment modules)
- `goldentooth.setup_hpc_software` (if installing HPC stack)
- `goldentooth.setup_slurm_modules` (if creating module files)

## Integration

- Part of the modular Slurm setup approach
- Replaces the heavy `goldentooth.setup_slurm` for basic needs  
- Works with other Slurm-related roles for full HPC environment

## Performance

- **Execution time**: ~30 seconds (vs 10+ minutes for full setup)
- **Network efficient**: Minimal downloads/builds
- **NFS friendly**: Only creates essential directories