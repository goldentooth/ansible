# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_vector_certs role.

## Overview

This role rotates TLS certificates for Vector log shipping service using Step-CA for secure log transmission.

## Purpose

- Rotate Vector TLS certificates
- Renew certificates before expiration
- Maintain secure log shipping
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Vector
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Vector service running
- Uses certificate renewal infrastructure

## Variables

- `vector.cert_path`: Certificate file path
- `vector.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_vector_certs' }
```

## Integration

Works with cert-renewer systemd timers for automated certificate renewal.