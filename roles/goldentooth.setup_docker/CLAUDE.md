# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_docker role.

## Overview

This role sets up Docker container platform for containerized workloads and development environments.

## Purpose

- Configure Docker container runtime
- Set up container management
- Configure Docker daemon settings
- Integrate with cluster container infrastructure

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Docker installation and configuration
- Container runtime setup
- Daemon configuration and optimization
- Integration with cluster services

## Dependencies

- Uses geerlingguy.docker role for base installation
- Requires appropriate system permissions
- Integrates with cluster networking

## Variables

- Docker configuration variables
- Container runtime settings
- Network and storage configuration

## Usage

Typically called via the setup_docker playbook:
```yaml
- { role: 'goldentooth.setup_docker' }
```

## Integration

Works with Kubernetes and other container orchestration systems.