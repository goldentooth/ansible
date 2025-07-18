# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_grafana_certs role.

## Overview

This role rotates TLS certificates for Grafana dashboard service using Step-CA for secure access.

## Purpose

- Rotate Grafana TLS certificates
- Renew certificates before expiration
- Maintain secure Grafana access
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Grafana
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Grafana service running
- Uses certificate renewal infrastructure

## Variables

- `grafana.cert_path`: Certificate file path
- `grafana.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_grafana_certs' }
```

## Integration

Works with cert-renewer systemd timers for automated certificate renewal.