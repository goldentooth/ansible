# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.install_step_ca role.

## Overview

This role installs and configures Step-CA certificate authority server for cluster-wide PKI infrastructure.

## Purpose

- Install Step-CA certificate authority
- Configure CA server settings
- Set up systemd service for CA
- Prepare for cluster certificate management

## Files

- `tasks/main.yaml`: Main task file
- `templates/step-ca.service.j2`: Systemd service template

## Key Features

- Step-CA installation and configuration
- Systemd service setup
- CA server configuration
- PKI infrastructure foundation

## Dependencies

- Requires Step-CA packages to be available
- Uses cluster configuration variables
- Integrates with certificate management

## Variables

- `step_ca.*`: Step-CA configuration variables
- CA server settings and paths
- Certificate authority configuration

## Usage

Typically called via the install_step_ca playbook:
```yaml
- { role: 'goldentooth.install_step_ca' }
```

## Integration

Works with CA initialization and certificate management roles.