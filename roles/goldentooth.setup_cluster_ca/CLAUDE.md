# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_cluster_ca role.

## Overview

This role sets up the cluster Certificate Authority (CA) system components including certificate distribution, system trust store updates, and automated certificate renewal system. It handles the ongoing operational aspects of the cluster CA after initial bootstrapping.

## Purpose

- Retrieve and distribute cluster CA information and certificates
- Update system trust store with cluster CA certificate  
- Install systemd service and timer templates for certificate renewal
- Configure automated certificate renewal system across the cluster

## Files

- `files/cert-renewer@.service`: Systemd service template for certificate renewal
- `files/cert-renewer@.timer`: Systemd timer template for automated renewal
- `tasks/main.yaml`: Main task file

## Key Features

### Certificate Distribution
- Retrieves CA certificate from the CA server
- Distributes cluster CA certificate to shared certificate path
- Updates system trust store with cluster CA

### Certificate Renewal System  
- Uses systemd templates for service management
- Implements timer-based automatic renewal
- Integrates with Step-CA for certificate issuance
- Supports per-service certificate renewal

### Service Template Pattern
The role uses systemd template units (`@` syntax) to create reusable certificate renewal services that can be instantiated for different services (e.g., `cert-renewer@consul.service`).

## Dependencies

- Requires Step-CA to be installed and configured
- Depends on cluster CA being bootstrapped via `goldentooth.bootstrap_cluster_ca`
- Uses variables from `step_ca` configuration

## Usage

This role is typically called after bootstrapping the cluster CA:
```yaml
- { role: 'goldentooth.setup_cluster_ca' }
```

## Integration

Works with other certificate management roles:
- Certificate rotation for Consul, Nomad, Vault, Grafana, and Vector is now integrated into their respective setup roles
- `goldentooth.rotate_loki_certs`
- And other service-specific certificate rotation roles

## Security Considerations

- Ensures secure certificate renewal process
- Maintains proper file permissions for certificate files
- Integrates with cluster-wide PKI infrastructure
- Updates system trust store for cluster-wide certificate validation