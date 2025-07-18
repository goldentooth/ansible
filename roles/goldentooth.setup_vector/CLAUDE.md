# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_vector role.

## Overview

This role sets up Vector log shipping and processing for centralized log management across the cluster.

## Purpose

- Configure Vector for log collection and shipping
- Set up log processing and transformation
- Configure secure log transmission
- Integrate with log aggregation systems

## Files

- `tasks/main.yaml`: Main task file
- `templates/vector.yaml.j2`: Vector configuration template
- `templates/cert-renewer@vector.conf.j2`: Certificate renewal configuration

## Key Features

- Log collection from multiple sources
- Log processing and transformation
- Secure log transmission with TLS
- Integration with Loki and other log systems

## Dependencies

- Requires Step-CA for certificate management
- Integrates with Loki for log aggregation
- Uses Consul for service discovery

## Variables

- `vector.*`: Vector configuration variables
- Certificate paths and renewal settings
- Log sources and destinations

## Usage

Typically called via the setup_vector playbook:
```yaml
- { role: 'goldentooth.setup_vector' }
```

## Integration

Works with Loki for log aggregation and Consul for service discovery.