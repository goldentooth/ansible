# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_envoy role.

## Overview

This role sets up Envoy proxy for advanced traffic management and service mesh capabilities within the cluster.

## Purpose

- Configure Envoy proxy for traffic management
- Set up service mesh capabilities
- Configure load balancing and routing
- Integrate with cluster services

## Files

- `tasks/main.yaml`: Main task file
- `templates/envoy.yaml.j2`: Envoy configuration template

## Key Features

- Advanced traffic routing and load balancing
- Service mesh integration
- HTTP/gRPC proxy capabilities
- Integration with cluster networking

## Dependencies

- Requires network configuration
- Integrates with cluster services
- Uses cluster networking infrastructure

## Variables

- Network configuration variables
- Service discovery settings
- Proxy configuration parameters

## Usage

Typically called via the setup_envoy playbook:
```yaml
- { role: 'goldentooth.setup_envoy' }
```

## Integration

Works with HAProxy and other networking components for comprehensive traffic management.