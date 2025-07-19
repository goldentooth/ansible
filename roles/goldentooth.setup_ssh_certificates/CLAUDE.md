# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_ssh_certificates role.

## Overview

This role configures SSH certificate-based authentication using Step-CA, enabling secure, passwordless SSH access between all cluster nodes without managing individual SSH keys.

## Purpose

- Configure SSH daemons to trust Step-CA certificates
- Generate SSH host certificates for each node
- Configure SSH clients to trust Step-CA signed hosts
- Set up automatic certificate renewal
- Enable cluster-wide SSH access using certificates

## Files

- `tasks/main.yaml`: Main task file
- `handlers/main.yaml`: Service restart handlers
- `templates/ssh-cert-renewer.service.j2`: Systemd service for certificate renewal
- `templates/ssh-cert-renewer.timer.j2`: Systemd timer for automatic renewal

## Key Features

### SSH Certificate Configuration
- Installs Step-CA public keys for user and host certificates
- Configures sshd to trust user certificates
- Configures sshd to present host certificates
- Sets up SSH client to trust host certificates

### Automatic Certificate Management
- Generates SSH host certificates with multiple principals
- Creates systemd timer for certificate renewal every 15 minutes (with 5m jitter)
- Automatically reloads SSH daemon after renewal

### Security Benefits
- No SSH keys to manage or rotate
- Certificates expire automatically
- Centralized trust through Step-CA
- Audit trail of all certificate issuance

## Dependencies

- Requires Step-CA to be installed and initialized
- Depends on cluster CA certificate being present
- Uses Step CLI tools for certificate operations

## Variables

Key variables from inventory:
- `step_ca.fqdn`: Step-CA server FQDN
- `step_ca.port`: Step-CA server port
- `cluster_name`: Cluster name for paths
- `cluster.domain`: Cluster domain for principals
- `cluster.node_domain`: Node domain for principals

## Usage

This role is typically called via a playbook:
```yaml
- hosts: all_nodes
  roles:
    - goldentooth.setup_ssh_certificates
```

## Integration

Works with:
- `goldentooth.init_cluster_ca`: Uses CA created by this role
- `goldentooth.install_step_ca`: Requires Step-CA server
- All services requiring SSH access between nodes

## Security Considerations

- Host certificates include multiple principals for flexibility
- Certificates are short-lived (renewed daily)
- No password/key authentication needed between cluster nodes
- StrictHostKeyChecking disabled within cluster for convenience