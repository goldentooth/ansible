# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_nomad_certs role.

## Overview

This role rotates TLS certificates for HashiCorp Nomad workload orchestration service using Step-CA for secure communication.

## Purpose

- Rotate Nomad TLS certificates
- Renew certificates before expiration
- Maintain secure workload orchestration
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Nomad
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Nomad service running
- Uses certificate renewal infrastructure

## Variables

- `nomad.cert_path`: Certificate file path
- `nomad.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_nomad_certs' }
```

## Integration

Works with cert-renewer systemd timers for automated certificate renewal.