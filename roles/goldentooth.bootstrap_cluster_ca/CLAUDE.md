# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.bootstrap_cluster_ca role.

## Overview

This role bootstraps the cluster Certificate Authority (CA) system with automated certificate renewal capabilities. It sets up systemd services and timers for automatic certificate renewal across the cluster.

## Purpose

- Install systemd service and timer templates for certificate renewal
- Configure automated certificate renewal system
- Enable certificate renewal timers on appropriate nodes

## Files

- `files/cert-renewer@.service`: Systemd service template for certificate renewal
- `files/cert-renewer@.timer`: Systemd timer template for automated renewal
- `tasks/main.yaml`: Main task file

## Key Features

### Certificate Renewal System
- Uses systemd templates for service management
- Implements timer-based automatic renewal
- Integrates with Step-CA for certificate issuance
- Supports per-service certificate renewal

### Service Template Pattern
The role uses systemd template units (`@` syntax) to create reusable certificate renewal services that can be instantiated for different services (e.g., `cert-renewer@consul.service`).

## Dependencies

- Requires Step-CA to be installed and configured
- Depends on cluster CA being initialized
- Uses variables from `step_ca` configuration

## Usage

This role is typically called as part of the cluster bootstrap process:
```yaml
- { role: 'goldentooth.bootstrap_cluster_ca' }
```

## Integration

Works with other certificate rotation roles:
- `goldentooth.rotate_consul_certs`
- `goldentooth.rotate_nomad_certs`
- `goldentooth.rotate_vault_certs`
- And other service-specific certificate rotation roles

## Security Considerations

- Ensures secure certificate renewal process
- Maintains proper file permissions for certificate files
- Integrates with cluster-wide PKI infrastructure