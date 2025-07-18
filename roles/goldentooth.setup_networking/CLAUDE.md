# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_networking role.

## Overview

This role configures network settings and routing for cluster nodes to ensure proper connectivity and communication.

## Purpose

- Configure network interfaces and routing
- Set up cluster networking infrastructure
- Configure network services and protocols
- Ensure proper inter-node communication

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Network interface configuration
- Routing table management
- Network service setup
- Inter-node communication setup

## Dependencies

- Requires appropriate network hardware
- Uses cluster networking configuration
- Integrates with system networking stack

## Variables

- `network.*`: Network configuration variables
- Interface and routing settings
- Cluster networking parameters

## Usage

Typically called via the setup_networking playbook:
```yaml
- { role: 'goldentooth.setup_networking' }
```

## Integration

Works with all cluster services that require network connectivity.