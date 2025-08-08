# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_venv role.

## Overview

This role sets up per-user Python virtual environments (for both root and regular users) that are automatically activated via ~/.bash_local configuration.

## Purpose

- Create standardized Python virtual environments for each user
- Set up automatic activation via ~/.bash_local
- Provide consistent Python development environment across cluster nodes
- Support both root and regular user environments

## Files

- `tasks/main.yaml`: Main task file for virtual environment setup
- `templates/venv_init.sh.j2`: Template for virtual environment initialization script

## Key Features

- Creates ~/.venv directory for each user
- Sets up Python virtual environment with latest Python available
- Configures automatic activation via ~/.bash_local
- Supports both system Python and user-specific Python versions
- Installs common development packages in the virtual environment

## Dependencies

- Python3 and python3-venv must be available on the system
- ~/.bash_local must exist and be sourced from ~/.bashrc
- Integrates with goldentooth.setup_user role

## Variables

- Uses system Python by default
- Virtual environment created in ~/.venv
- Can be customized per-user if needed

## Usage

Typically called as part of user configuration:
```yaml
- { role: 'goldentooth.setup_venv' }
```

## Integration

This role works with goldentooth.setup_user to ensure ~/.bash_local exists and is properly sourced from ~/.bashrc for seamless virtual environment activation.