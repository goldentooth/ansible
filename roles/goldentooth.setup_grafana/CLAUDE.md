# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_grafana role.

## Overview

This role sets up Grafana for observability dashboards with TLS encryption, automated dashboard provisioning, and certificate renewal.

## Purpose

- Configure Grafana server with TLS encryption
- Set up automated dashboard provisioning
- Configure data source connections
- Set up automatic certificate renewal
- Configure dashboard update automation

## Files

- `tasks/main.yaml`: Main task file
- `templates/grafana.ini.j2`: Main Grafana configuration template
- `templates/cert-renewer@grafana.conf.j2`: Certificate renewal configuration
- `templates/provisioners.dashboards.yaml.j2`: Dashboard provisioning configuration
- `templates/provisioners.datasources.yaml.j2`: Data source provisioning configuration
- `templates/cron.update_dashboards.j2`: Cron job for dashboard updates
- `templates/script.update_dashboards.sh.j2`: Dashboard update script

## Key Features

### TLS Security
- Implements TLS for all Grafana communication
- Uses Step-CA for certificate management
- Automatic certificate renewal via systemd timers

### Dashboard Provisioning
- Automated dashboard provisioning from Git repositories
- Updates dashboards via cron job
- Supports multiple dashboard sources

### Data Source Integration
- Configures Prometheus as primary data source
- Supports multiple data source types
- Automatic data source provisioning

### Authentication
- Configures admin authentication
- Uses vault for credential management
- Supports external authentication providers

## Dependencies

- Requires Step-CA for certificate management
- Depends on Prometheus for data source
- Uses admin password from vault
- Requires Git for dashboard provisioning

## Variables

Key variables from inventory:
- `grafana.admin_password`: Admin password from vault
- `grafana.certs_path`: Certificate storage path
- `grafana.provisioners.dashboards.repository_name`: Dashboard repository

## Usage

This role is typically called via the setup_grafana playbook:
```yaml
- { role: 'goldentooth.setup_grafana' }
```

## Integration

Works with:
- `goldentooth.setup_prometheus`: Data source integration
- `goldentooth.rotate_grafana_certs`: Certificate rotation
- `goldentooth.setup_loki`: Log data source
- Git repositories for dashboard provisioning

## Security Considerations

- All communication encrypted with TLS
- Secure admin authentication
- Certificates automatically renewed
- Secure data source connections