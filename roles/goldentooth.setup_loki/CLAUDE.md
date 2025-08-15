# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_loki role.

## Overview

This is a unified role that handles complete Loki setup including installation, certificate management, TLS encryption, Consul integration, and certificate renewal. It consolidates the functionality previously split across setup_loki and rotate_loki_certs roles.

## Purpose

- Generate TLS certificates for Loki service
- Configure Loki log aggregation server
- Set up TLS encryption for Loki communication
- Configure Consul integration with ACL policies
- Set up automatic certificate renewal
- Configure log retention and storage

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/manage_certificates.yaml`: Certificate generation and management
- `templates/loki.yml.j2`: Main Loki configuration template
- `templates/cert-renewer@loki.conf.j2`: Certificate renewal configuration
- `files/loki.policy.hcl`: Consul ACL policy

## Key Features

### Unified Operations
- Single role handles complete Loki lifecycle
- Automatic certificate generation and renewal
- Integrated Consul ACL policy management
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### Certificate Management
- Generates TLS certificates using Step-CA
- Handles certificate renewal automatically
- Integrates with systemd timer-based renewal

### TLS Security
- Implements TLS for all Loki communication
- Uses Step-CA for certificate management
- Automatic certificate renewal via systemd timers

### Consul Integration
- Integrates with Consul for service discovery
- Uses Consul ACL system for security
- Leverages Consul for configuration management

### Log Storage
- Configures local storage for log data
- Supports retention policies
- Optimizes storage for log workloads

### API Access
- Provides secure API for log queries
- Integrates with Grafana for visualization
- Supports LogQL query language

## Dependencies

- Requires Consul to be configured and running
- Depends on Step-CA for certificate management
- Uses Consul ACL tokens for authentication
- Requires proper network configuration

## Variables

Key variables from inventory:
- `loki.consul.policy_name`: Consul ACL policy name
- `loki.certs_path`: Certificate storage path
- `loki.cert_path`: Certificate file path
- `loki.key_path`: Private key file path

## Usage

This role is typically called via the setup_loki playbook:
```yaml
- { role: 'goldentooth.setup_loki' }
```

## Integration

Works with:
- `goldentooth.setup_consul`: Service discovery and ACL integration
- `goldentooth.setup_grafana`: Visualization integration
- `goldentooth.setup_vector`: Log shipping

## Security Considerations

- All communication encrypted with TLS
- Consul ACL integration for security
- Certificates automatically renewed
- Secure log data storage