# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_nomad role.

## Overview

This is a unified role that handles complete Nomad setup including server and client configuration, certificate management, and cluster-wide CLI access. It consolidates the functionality previously split across setup_nomad and rotate_nomad_certs roles while providing cluster-wide CLI access similar to Consul and Vault roles.

## Purpose

- Install Nomad CLI on all cluster nodes
- Generate TLS certificates for Nomad servers and clients
- Configure Nomad servers and clients in HA mode
- Set up cluster-wide CLI access from all nodes
- Configure Consul integration for service discovery
- Set up automatic certificate renewal
- Configure GPU and compute node classifications

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/manage_certificates.yaml`: Certificate generation and management
- `templates/nomad.hcl.j2`: Main Nomad configuration template
- `templates/nomad.env.j2`: Environment variable template
- `templates/nomad.service.j2`: Systemd service template
- `templates/nomad-env.sh.j2`: System-wide environment variables
- `templates/cert-renewer@nomad.conf.j2`: Certificate renewal configuration
- `templates/cert-renewer@nomad-cli.conf.j2`: CLI certificate renewal configuration
- `files/nomad.server.policy.hcl`: Server ACL policy
- `files/nomad.client.policy.hcl`: Client ACL policy

## Key Features

### Unified Operations
- Single role handles complete Nomad lifecycle
- Installs CLI on all nodes for cluster-wide access
- Server and client configuration based on host groups
- Automatic certificate generation and renewal
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### Dual Role Support
- Configures both Nomad servers and clients based on host groups
- Uses `nomad.role` variable to determine configuration type
- Servers form a cluster, clients register with servers

### Certificate Management
- Generates TLS certificates using Step-CA
- Handles certificate renewal automatically
- Integrates with systemd timer-based renewal
- Separate certificates for server and CLI access

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
- `goldentooth.setup_vault`: Vault integration
- Kubernetes cluster for hybrid orchestration

## Security Considerations

- All communication encrypted with TLS
- ACL policies for server and client access
- Certificates automatically renewed
- Secure integration with Consul ACL system