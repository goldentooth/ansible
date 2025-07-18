# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_conda role.

## Overview

This role sets up Conda environment management for Python-based workloads and scientific computing.

## Purpose

- Install and configure Conda package manager
- Set up Python environments
- Configure package management for scientific computing
- Integrate with distributed computing frameworks

## Files

- `tasks/main.yaml`: Main task file
- `defaults/main.yaml`: Default configuration variables

## Key Features

- Conda installation and configuration
- Python environment management
- Scientific computing package support
- Integration with Ray and other frameworks

## Dependencies

- Requires appropriate Python versions
- Integrates with distributed computing setup
- Uses cluster storage for shared environments

## Variables

- `python.*`: Python version configuration
- Conda environment settings
- Package management configuration

## Usage

Typically called via compute workload setup:
```yaml
- { role: 'goldentooth.setup_conda' }
```

## Integration

Works with Ray and Slurm for distributed computing and job scheduling.