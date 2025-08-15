# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_seaweedfs role.

## Overview

This is a unified role that handles complete SeaweedFS setup including installation, certificate management, TLS encryption, Consul integration, and certificate renewal. It consolidates the functionality previously split across setup_seaweedfs and rotate_seaweedfs_certs roles.

## Purpose

- Generate TLS certificates for SeaweedFS services
- Install and configure SeaweedFS master and volume servers
- Set up TLS encryption for SeaweedFS communication
- Configure Consul integration for service discovery
- Set up automatic certificate renewal
- Configure Prometheus monitoring integration

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/manage_certificates.yaml`: Certificate generation and management
- `templates/seaweedfs-master-simple.service.j2`: Master server systemd service
- `templates/seaweedfs-volume-simple.service.j2`: Volume server systemd service
- `templates/cert-renewer@seaweedfs.conf.j2`: Certificate renewal configuration
- `templates/seaweedfs-master-consul-service.json.j2`: Consul service registration for master
- `templates/seaweedfs-volume-consul-service.json.j2`: Consul service registration for volume
- `templates/seaweedfs-targets.yaml.j2`: Prometheus monitoring targets

## Key Features

### Unified Operations
- Single role handles complete SeaweedFS lifecycle
- Automatic certificate generation and renewal
- Integrated Consul service discovery
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### Certificate Management
- Generates TLS certificates using Step-CA
- Handles certificate renewal automatically
- Integrates with systemd timer-based renewal
- Multiple SANs for flexible access patterns

### Distributed Storage
- Sets up both master and volume servers
- Configures proper data directories and permissions
- Health checks for service readiness
- Automatic service startup and management

### Service Discovery
- Registers services with Consul
- Provides health checks for monitoring
- Enables service-to-service communication
- Integrates with cluster-wide service mesh

### Monitoring Integration
- Configures Prometheus scraping targets
- Exposes metrics endpoints for monitoring
- Integrates with cluster-wide observability

## Dependencies

- Requires Step-CA for certificate management
- Depends on Consul for service discovery
- Uses cluster-wide certificate renewal infrastructure
- Requires proper network configuration

## Variables

Key variables from inventory:
- `seaweedfs.version`: SeaweedFS version to install
- `seaweedfs.mount_path`: Base path for SeaweedFS data
- `seaweedfs.certs_path`: Certificate storage path
- `seaweedfs.uid/gid`: User/group for SeaweedFS processes
- `cluster_domain`: Domain for certificate SANs

## Usage

This role is typically called via the setup_seaweedfs playbook:
```yaml
- { role: 'goldentooth.setup_seaweedfs' }
```

## Integration

Works with:
- `goldentooth.setup_consul`: Service discovery integration
- `goldentooth.setup_prometheus`: Monitoring integration
- `goldentooth.bootstrap_seaweedfs`: Initial cluster bootstrap

## Security Considerations

- All communication encrypted with TLS
- Proper file permissions for certificates and data
- Certificates automatically renewed
- Secure service discovery via Consul
- Network-level access controls