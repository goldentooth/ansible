# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_vault role.

## Overview

This is a unified role that handles complete Vault setup including server configuration, client CLI access, certificate management, and Consul integration. It consolidates the functionality previously split across setup_vault and rotate_vault_certs roles while providing cluster-wide CLI access like the setup_consul role.

## Purpose

- Install Vault CLI on all cluster nodes
- Generate TLS certificates for Vault servers
- Configure Vault servers in HA mode
- Set up client access from non-server nodes
- Configure AWS KMS auto-unseal
- Set up Consul backend for storage
- Configure automatic certificate renewal

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/manage_certificates.yaml`: Certificate generation and management
- `templates/vault.hcl.j2`: Main Vault configuration template
- `templates/vault.env.j2`: Environment variable template
- `templates/vault.service.j2`: Systemd service template
- `templates/cert-renewer@vault.conf.j2`: Certificate renewal configuration
- `files/vault.policy.hcl`: Vault ACL policy

## Key Features

### Unified Operations
- Single role handles complete Vault lifecycle
- Installs CLI on all nodes for cluster-wide access
- Server and client configuration based on host groups
- Automatic certificate generation and renewal
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### Certificate Management
- Generates TLS certificates using Step-CA
- Handles certificate renewal automatically
- Integrates with systemd timer-based renewal

### High Availability
- Configures Vault in HA mode with Consul storage
- Uses Consul for service discovery
- Supports multiple Vault servers for redundancy

### TLS Security
- Implements TLS for all Vault communication
- Uses Step-CA for certificate management
- Automatic certificate renewal via systemd timers

### AWS KMS Auto-Unseal
- Configures AWS KMS for automatic unsealing
- Uses AWS credentials from vault
- Eliminates need for manual unsealing

### Consul Backend
- Uses Consul as backend storage
- Integrates with Consul ACL system
- Leverages Consul's clustering capabilities

## Dependencies

- Requires Consul to be configured and running
- Depends on Step-CA for certificate management
- Requires AWS credentials for KMS access
- Uses Consul ACL tokens for backend access

## Variables

Key variables from inventory:
- `vault.aws.access_key_id`: AWS access key
- `vault.aws.secret_access_key`: AWS secret key
- `vault.seal_kms_key_alias`: KMS key alias
- `vault.cluster_name`: Vault cluster name

## Usage

This role is typically called via the setup_vault playbook:
```yaml
- { role: 'goldentooth.setup_vault' }
```

## Integration

Works with:
- `goldentooth.setup_consul`: Backend storage
- `goldentooth.setup_nomad`: Secrets integration
- AWS KMS for auto-unseal

## Security Considerations

- All communication encrypted with TLS
- AWS KMS for secure unsealing
- Consul ACL integration for backend security
- Certificates automatically renewed
- Secure storage of recovery keys in vault