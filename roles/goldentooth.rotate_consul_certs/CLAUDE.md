# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.rotate_consul_certs role.

## Overview

This role rotates TLS certificates for Consul services using Step-CA, ensuring secure communication across the service mesh.

## Purpose

- Rotate Consul TLS certificates
- Renew certificates before expiration
- Maintain secure Consul communication
- Integrate with automated renewal system

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Certificate rotation for Consul
- Integration with Step-CA
- Automated renewal process
- Service restart coordination

## Dependencies

- Requires Step-CA to be configured
- Depends on Consul service running
- Uses certificate renewal infrastructure

## Variables

- `consul.cert_path`: Certificate file path
- `consul.key_path`: Private key file path
- Step-CA configuration variables

## Usage

Typically called via certificate rotation playbook:
```yaml
- { role: 'goldentooth.rotate_consul_certs' }
```