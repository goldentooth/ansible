# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_ray role.

## Overview

This role sets up Ray distributed computing framework for machine learning and parallel processing workloads.

## Purpose

- Configure Ray head and worker nodes
- Set up distributed computing cluster
- Configure Python environments for Ray
- Integrate with cluster networking

## Files

- `tasks/main.yaml`: Main task file
- `templates/ray.service.j2`: Systemd service template
- `templates/start_ray.sh.j2`: Ray startup script template

## Key Features

- Distributed computing cluster setup
- Head and worker node configuration
- Python environment integration
- Systemd service management

## Dependencies

- Requires Python and Conda environments
- Uses cluster networking configuration
- Integrates with distributed computing infrastructure

## Variables

- `ray.*`: Ray configuration variables
- Python version and environment settings
- Head and worker node configuration

## Usage

Typically called via the setup_ray playbook:
```yaml
- { role: 'goldentooth.setup_ray' }
```

## Integration

Works with Python environments and cluster networking for distributed computing.