# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.bootstrap_cluster_ca role.

## Overview

This role performs the initial bootstrapping of the cluster Certificate Authority (CA) system. It connects nodes to the Step-CA server and sets up the basic client configuration needed to interact with the cluster CA.

## Purpose

- Bootstrap Step-CA client configuration on cluster nodes
- Retrieve CA server information and fingerprint
- Execute the initial `step ca bootstrap` command
- Set up JWK provisioner password file for authentication

## Files

- `tasks/main.yaml`: Main task file containing bootstrap tasks

## Key Features

### Initial CA Bootstrap
- Retrieves CA server configuration from the Step-CA server
- Executes `step ca bootstrap` to initialize client configuration
- Sets up provisioner credentials for certificate requests

### One-Time Operation
This role should only be run once during initial cluster setup. Subsequent CA-related operations should use `goldentooth.setup_cluster_ca` or service-specific certificate rotation roles.

## Dependencies

- Requires Step-CA to be installed and configured
- Depends on cluster CA being initialized
- Uses variables from `step_ca` configuration

## Usage

This role is typically called as part of the cluster bootstrap process:
```yaml
- { role: 'goldentooth.bootstrap_cluster_ca' }
```

## Integration

Works with other certificate management roles:
- Certificate rotation for Consul, Nomad, Vault, Grafana, Vector, and Loki is now integrated into their respective setup roles
- And other service-specific certificate rotation roles

## Security Considerations

- Ensures secure certificate renewal process
- Maintains proper file permissions for certificate files
- Integrates with cluster-wide PKI infrastructure