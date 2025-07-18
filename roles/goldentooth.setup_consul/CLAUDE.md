# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_consul role.

## Overview

This role sets up HashiCorp Consul service mesh across the cluster, configuring both server and client nodes with TLS encryption, ACL policies, and certificate renewal.

## Purpose

- Configure Consul servers and clients
- Set up TLS encryption for Consul communication
- Configure ACL policies for security
- Set up automatic certificate renewal
- Configure Consul integration with other services

## Files

- `tasks/main.yaml`: Main task file
- `tasks/update_config.yaml`: Configuration update tasks
- `templates/consul.hcl.j2`: Main Consul configuration template
- `templates/consul.env.j2`: Environment variable template
- `templates/consul.service.j2`: Systemd service template
- `templates/consul.agent.policy.hcl.j2`: ACL policy template
- `templates/cert-renewer@consul.conf.j2`: Certificate renewal configuration

## Key Features

### Dual Role Support
- Configures both Consul servers and clients based on host groups
- Uses `consul.role` variable to determine configuration type
- Servers form a cluster, clients connect to servers

### TLS Security
- Implements mutual TLS for all Consul communication
- Uses Step-CA for certificate management
- Automatic certificate renewal via systemd timers

### ACL System
- Configures ACL policies for secure access
- Creates node-specific policies
- Integrates with management token from vault

### Service Integration
- Registers services with Consul
- Provides service discovery for other cluster services
- Integrates with Nomad for workload orchestration

## Dependencies

- Requires Step-CA for certificate management
- Depends on bootstrap_cluster_ca role
- Uses Consul management token from vault
- Requires proper network configuration

## Variables

Key variables from inventory:
- `consul.role`: Determines if node is server or client
- `consul.datacenter`: Consul datacenter name
- `consul.mgmt_token`: Management token from vault
- `consul.certs_path`: Certificate storage path

## Usage

This role is typically called via the setup_consul playbook:
```yaml
- { role: 'goldentooth.setup_consul' }
```

## Integration

Works with:
- `goldentooth.bootstrap_consul_acl`: ACL system setup
- `goldentooth.rotate_consul_certs`: Certificate rotation
- `goldentooth.setup_nomad`: Nomad integration
- `goldentooth.setup_vault`: Vault integration

## Security Considerations

- All communication encrypted with TLS
- ACL system provides fine-grained access control
- Certificates automatically renewed
- Secure token management via vault