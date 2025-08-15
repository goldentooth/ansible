# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_vector role.

## Overview

This is a unified role that handles complete Vector setup including installation, certificate management, TLS encryption, log processing configuration, and certificate renewal. It consolidates the functionality previously split across setup_vector and rotate_vector_certs roles.

## Purpose

- Generate TLS certificates for Vector service
- Configure Vector for log collection and shipping
- Set up log processing and transformation
- Configure secure log transmission with TLS
- Set up automatic certificate renewal
- Integrate with log aggregation systems

## Files

- `tasks/main.yaml`: Main orchestration file
- `tasks/manage_certificates.yaml`: Certificate generation and management
- `templates/vector.yaml.j2`: Vector configuration template
- `templates/cert-renewer@vector.conf.j2`: Certificate renewal configuration

## Key Features

### Unified Operations
- Single role handles complete Vector lifecycle
- Automatic certificate generation and renewal
- Integrated log processing configuration
- Idempotent - safe to run multiple times
- Atomic operations - either succeeds completely or fails cleanly

### Certificate Management
- Generates TLS certificates using Step-CA
- Handles certificate renewal automatically
- Integrates with systemd timer-based renewal

### Log Processing
- Log collection from multiple sources
- Log processing and transformation
- Secure log transmission with TLS
- Integration with Loki and other log systems

## Dependencies

- Requires Step-CA for certificate management
- Integrates with Loki for log aggregation
- Uses Consul for service discovery

## Variables

- `vector.*`: Vector configuration variables
- Certificate paths and renewal settings
- Log sources and destinations

## Usage

Typically called via the setup_vector playbook:
```yaml
- { role: 'goldentooth.setup_vector' }
```

## Integration

Works with Loki for log aggregation and Consul for service discovery.