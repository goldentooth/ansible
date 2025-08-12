# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_consul role.

## Overview

This is a unified role that handles complete Consul setup including ACL bootstrap, role-aware certificate management, and service configuration. It consolidates the functionality previously split across bootstrap_consul, setup_consul, and rotate_consul_certs roles.

## Purpose

- Bootstrap ACL system and generate management tokens (one-time operation)
- Generate role-appropriate certificates (server vs client)
- Configure Consul servers and clients
- Set up TLS encryption for Consul communication
- Configure ACL policies for security
- Set up automatic certificate renewal
- Handle role changes automatically

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/bootstrap_acl.yaml`: ACL bootstrap logic (one-time operations)
- `tasks/manage_certificates.yaml`: Role-aware certificate management
- `tasks/update_config.yaml`: Configuration update tasks
- `templates/consul.hcl.j2`: Main Consul configuration template
- `templates/consul.env.j2`: Environment variable template
- `templates/consul.service.j2`: Systemd service template
- `templates/consul.agent.policy.hcl.j2`: ACL policy template
- `templates/cert-renewer@consul.conf.j2`: Certificate renewal configuration

## Key Features

### Unified Operations
- Single role handles complete Consul lifecycle
- Automatic role change detection and certificate regeneration
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### ACL Bootstrap Management
- Detects if ACL system needs bootstrapping
- Generates gossip keys and management tokens
- Handles bootstrap failures and retries
- One-time operations run only when needed

### Intelligent Certificate Management
- Detects certificate role mismatches (server vs client)
- Automatically regenerates certificates when roles change
- Verifies certificate subject matches required role
- Integrates with Step-CA for secure certificate generation

### Dual Role Support
- Configures both Consul servers and clients based on host groups
- Uses `consul.role` variable to determine configuration type
- Servers form a cluster, clients connect to servers

### TLS Security
- Implements mutual TLS for all Consul communication
- Role-appropriate certificate generation
- Automatic certificate renewal via systemd timers

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