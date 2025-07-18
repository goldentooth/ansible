# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.init_cluster_ca role.

## Overview

This role initializes the cluster's root and intermediate Certificate Authority (CA) using Step-CA, setting up the foundation for cluster-wide PKI infrastructure.

## Purpose

- Initialize Step-CA root certificate authority
- Create intermediate certificate authority
- Configure CA provisioners
- Set up CA password management
- Establish cluster PKI foundation

## Files

- `tasks/main.yaml`: Main task file

## Key Features

### CA Initialization
- Creates root CA with cluster-specific configuration
- Generates intermediate CA for day-to-day operations
- Configures CA with appropriate validity periods

### Provisioner Setup
- Configures JWK provisioner for certificate issuance
- Sets up provisioner passwords securely
- Enables automated certificate workflows

### Security Configuration
- Uses secure password management from vault
- Configures appropriate key sizes and algorithms
- Sets up CA with cluster-specific SANs

### Integration Ready
- Prepares CA for cluster-wide certificate issuance
- Configures for integration with renewal systems
- Sets up foundation for TLS across all services

## Dependencies

- Requires Step-CA to be installed
- Uses passwords from vault configuration
- Requires proper network configuration
- Depends on cluster naming conventions

## Variables

Key variables from inventory:
- `step_ca.ca.name`: CA name (typically cluster name)
- `step_ca.ca.sans`: Subject Alternative Names
- `secret_vault.step_ca.passwords.*`: CA passwords from vault
- `step_ca.default_provisioner.*`: Provisioner configuration

## Usage

This role is typically called via the init_cluster_ca playbook:
```yaml
- { role: 'goldentooth.init_cluster_ca' }
```

## Integration

Works with:
- `goldentooth.bootstrap_cluster_ca`: CA bootstrap across cluster
- `goldentooth.install_step_ca`: Step-CA installation
- All certificate rotation roles
- TLS configuration across all services

## Security Considerations

- Secure generation of CA private keys
- Proper password management from vault
- Appropriate CA validity periods
- Secure storage of CA certificates
- Proper permissions for CA operations