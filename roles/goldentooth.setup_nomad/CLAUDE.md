# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_nomad role.

## Overview

This role sets up HashiCorp Nomad workload orchestration across the cluster, configuring both server and client nodes with TLS encryption, Consul integration, and certificate renewal.

## Purpose

- Configure Nomad servers and clients
- Set up TLS encryption for Nomad communication
- Configure Consul integration for service discovery
- Set up automatic certificate renewal
- Configure GPU and compute node classifications

## Files

- `tasks/main.yaml`: Main task file
- `templates/nomad.hcl.j2`: Main Nomad configuration template
- `templates/nomad.env.j2`: Environment variable template
- `templates/nomad.service.j2`: Systemd service template
- `templates/cert-renewer@nomad.conf.j2`: Certificate renewal configuration
- `templates/cert-renewer@nomad-cli.conf.j2`: CLI certificate renewal configuration
- `files/nomad.server.policy.hcl`: Server ACL policy
- `files/nomad.client.policy.hcl`: Client ACL policy

## Key Features

### Dual Role Support
- Configures both Nomad servers and clients based on host groups
- Uses `nomad.role` variable to determine configuration type
- Servers form a cluster, clients register with servers

### TLS Security
- Implements mutual TLS for all Nomad communication
- Uses Step-CA for certificate management
- Separate certificates for server and CLI access
- Automatic certificate renewal via systemd timers

### Consul Integration
- Integrates with Consul for service discovery
- Uses Consul for cluster coordination
- Leverages Consul's ACL system for security

### Node Classification
- Supports GPU and standard compute nodes
- Uses `nomad.client.node_class` for workload targeting
- Configures appropriate constraints and capabilities

## Dependencies

- Requires Consul to be configured and running
- Depends on Step-CA for certificate management
- Requires proper network configuration between nodes
- Uses Consul ACL tokens for authentication

## Variables

Key variables from inventory:
- `nomad.role`: Determines if node is server or client
- `nomad.datacenter`: Nomad datacenter name
- `nomad.client.node_class`: Node classification (gpu, default)
- `nomad.service_user`: Service user (nomad for servers, root for clients)

## Usage

This role is typically called via the setup_nomad playbook:
```yaml
- { role: 'goldentooth.setup_nomad' }
```

## Integration

Works with:
- `goldentooth.setup_consul`: Service discovery integration
- `goldentooth.rotate_nomad_certs`: Certificate rotation
- `goldentooth.setup_vault`: Vault integration
- Kubernetes cluster for hybrid orchestration

## Security Considerations

- All communication encrypted with TLS
- ACL policies for server and client access
- Certificates automatically renewed
- Secure integration with Consul ACL system