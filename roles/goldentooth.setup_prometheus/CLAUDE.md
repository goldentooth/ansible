# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_prometheus role.

## Overview

This role sets up Prometheus metrics collection system for cluster monitoring and observability.

## Purpose

- Configure Prometheus server for metrics collection
- Set up service discovery and scraping
- Configure alerting and recording rules
- Integrate with cluster monitoring stack

## Files

- `tasks/main.yaml`: Main task file
- `templates/prometheus.service.j2`: Systemd service template
- `templates/nginx-prometheus.conf.j2`: Nginx proxy configuration
- `templates/node.yaml.j2`: Node exporter configuration

## Key Features

- Metrics collection from cluster services
- Service discovery integration
- Alerting and recording rules
- Nginx proxy for secure access

## Dependencies

- Uses prometheus.prometheus.prometheus role
- Requires node exporters on cluster nodes
- Integrates with service discovery

## Variables

- `prometheus_*`: Prometheus configuration variables
- Scrape configuration and targets
- Alerting and recording rules

## Usage

Typically called via the setup_prometheus playbook:
```yaml
- { role: 'goldentooth.setup_prometheus' }
```

## Integration

Works with Grafana for visualization and alerting systems for monitoring.