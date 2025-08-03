# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_haproxy role.

## Overview

This role sets up HAProxy load balancer with Nginx for the cluster, providing load balancing for Kubernetes API server and other services.

## Purpose

- Configure HAProxy for load balancing
- Set up Nginx for reverse proxy and basic auth
- Configure load balancing for Kubernetes API server
- Set up HAProxy Data Plane API for dynamic configuration
- Configure monitoring and health checks

## Files

- `tasks/main.yaml`: Main task file
- `templates/haproxy.cfg.j2`: HAProxy configuration template
- `templates/dataplaneapi.yml.j2`: HAProxy Data Plane API configuration
- `templates/haproxy-dataplaneapi.service.j2`: Systemd service for Data Plane API
- `templates/nginx.basic_auth_gateway.conf.j2`: Nginx basic auth configuration
- `templates/nginx.zzz_metallb_services.conf.j2`: MetalLB service proxy configuration

## Key Features

### Load Balancing
- Configures HAProxy for Kubernetes API server load balancing
- Provides high availability for control plane
- Supports health checks and failover

### Nginx Integration
- Uses Nginx as reverse proxy for additional services
- Configures basic authentication for sensitive endpoints
- Provides SSL termination capabilities

### HAProxy Data Plane API
- Provides RESTful API for dynamic HAProxy configuration
- Enables runtime configuration changes without restarts
- Supports backend management, server weights, and health checks
- Available at https://haproxy-api.services.goldentooth.net
- Authenticated access using cluster credentials

### Monitoring
- Configures HAProxy stats endpoint
- Provides monitoring integration
- Sets up health check endpoints

## Dependencies

- Requires HAProxy and Nginx to be installed
- Depends on Kubernetes control plane nodes
- HAProxy Data Plane API binary downloaded from GitHub releases
- Requires proper network configuration
- Step-CA for TLS certificate management

## Variables

Key variables from inventory:
- `haproxy.hostname`: Load balancer hostname
- `haproxy.domain_name`: Load balancer domain
- `haproxy.nginx.user`: Nginx user account
- `kubernetes.first`: First control plane node

## Usage

This role is typically called via the setup_load_balancer playbook:
```yaml
- { role: 'goldentooth.setup_haproxy' }
```

## Integration

Works with:
- `goldentooth.bootstrap_k8s`: Kubernetes API load balancing
- MetalLB for service load balancing
- `goldentooth.setup_prometheus`: Monitoring integration
- `goldentooth.setup_node_homepages`: Web service proxying

## Security Considerations

- Secure configuration of proxy settings
- Basic authentication for sensitive endpoints
- Proper SSL/TLS configuration
- Access control for admin interfaces
- Secure backend connections