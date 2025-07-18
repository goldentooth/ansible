# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_vault_certs role.

## Overview

This role rotates TLS certificates for HashiCorp Vault secrets management service using Step-CA for secure access.

## Purpose

- Rotate Vault TLS certificates
- Renew certificates before expiration
- Maintain secure secrets management
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Vault
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Vault service running
- Uses certificate renewal infrastructure

## Variables

- `vault.cert_path`: Certificate file path
- `vault.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_vault_certs' }
```

## Integration

Works with cert-renewer systemd timers for automated certificate renewal.