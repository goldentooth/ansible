# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_user role.

## Overview

This role configures user accounts across cluster nodes with SSH keys, sudo access, and shell customization.

## Purpose

- Configure user accounts for cluster access
- Set up SSH key authentication
- Configure sudo access and shell settings
- Standardize user configuration across nodes

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- SSH key deployment for secure access
- Sudo configuration for administrative access
- Shell customization and environment setup
- Consistent user configuration across cluster

## Dependencies

- Uses SSH keys from vault configuration
- Requires appropriate system permissions
- Integrates with security configuration

## Variables

- `my.name.*`: User name configuration
- `secret_vault.ssh_public_key`: SSH public key from vault
- User-specific configuration variables

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.setup_user' }
```