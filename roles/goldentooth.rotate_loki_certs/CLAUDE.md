# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_loki_certs role.

## Overview

This role rotates TLS certificates for Loki log aggregation service using Step-CA for secure log transmission.

## Purpose

- Rotate Loki TLS certificates
- Renew certificates before expiration
- Maintain secure log aggregation
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Loki
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Loki service running
- Uses certificate renewal infrastructure

## Variables

- `loki.cert_path`: Certificate file path
- `loki.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_loki_certs' }
```

## Integration

Works with cert-renewer systemd timers for automated certificate renewal.