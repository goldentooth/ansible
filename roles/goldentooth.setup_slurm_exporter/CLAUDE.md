# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_slurm_exporter role.

## Overview

This role deploys and configures prometheus-slurm-exporter to collect Slurm workload manager metrics for monitoring and observability. The exporter runs on Slurm controller nodes and exposes job queue, node status, and resource utilization metrics to Prometheus.

## Purpose

- Install and configure prometheus-slurm-exporter
- Enable TLS-secured metrics collection
- Integrate with existing Prometheus monitoring stack
- Provide Slurm cluster visibility through metrics

## Key Features

- **Secure Communication**: TLS certificates via Step-CA
- **Automatic Discovery**: File-based service discovery for Prometheus
- **Resource Monitoring**: Job queues, node states, resource usage
- **High Availability**: Runs on all Slurm controller nodes
- **Certificate Renewal**: Automated TLS certificate lifecycle management

## Architecture

### Deployment Strategy
- **Target Nodes**: Slurm controller nodes (bettley, cargyll, dalt)
- **Port**: 8080 (HTTP) / 8443 (HTTPS with TLS)
- **Service User**: `slurm-exporter` with minimal permissions
- **Service Discovery**: File-based targets for Prometheus scraping

### Metrics Exposed
- `slurm_jobs_pending`: Number of pending jobs in queue
- `slurm_jobs_running`: Number of currently running jobs  
- `slurm_nodes_alloc`: Allocated nodes count
- `slurm_nodes_idle`: Idle nodes count
- `slurm_nodes_down`: Down/unavailable nodes count
- `slurm_cpus_total`: Total CPU cores in cluster
- `slurm_cpus_alloc`: Allocated CPU cores
- `slurm_memory_total`: Total memory in cluster (MB)
- `slurm_memory_alloc`: Allocated memory (MB)

## Files

- `tasks/main.yaml`: Main deployment tasks
- `templates/slurm-exporter.service.j2`: Systemd service configuration
- `templates/slurm_targets.yaml.j2`: Prometheus service discovery targets
- `templates/cert-renewer@slurm-exporter.conf.j2`: Certificate renewal configuration
- `handlers/main.yaml`: Service restart handlers

## Dependencies

### Required Services
- **Slurm**: Must be installed and operational
- **Step-CA**: For TLS certificate management
- **Prometheus**: For metrics collection (automatic discovery)

### Required Groups
- `slurm_controller`: Target nodes for exporter deployment
- `prometheus`: Prometheus server for metrics collection

## Variables

### Global Configuration
```yaml
prometheus_slurm_exporter:
  version: "0.20"
  port: 8080
  tls_port: 8443
  user: "slurm-exporter"
  group: "slurm-exporter"
```

### TLS Configuration
Uses cluster-wide Step-CA configuration from `inventory/group_vars/all/vars.yaml`

## Usage

### Initial Setup
```bash
goldentooth setup_slurm_exporter
```

### Certificate Management
```bash
# Rotate certificates
goldentooth rotate_slurm_exporter_certs

# Check certificate status
goldentooth command slurm_controller "systemctl status cert-renewer@slurm-exporter"
```

### Verification
```bash
# Check exporter status
goldentooth command slurm_controller "systemctl status slurm-exporter"

# Test metrics endpoint
goldentooth command slurm_controller "curl -s https://localhost:8443/metrics | head -20"

# Check Prometheus targets
goldentooth command allyrion "curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.job==\"slurm\")'"
```

## Integration

### Prometheus Configuration
The role automatically creates service discovery targets that are consumed by the Prometheus server running on `allyrion`. The configuration is added to the existing `prometheus_scrape_configs` in group variables.

### Grafana Dashboards
Metrics are available for Grafana dashboard creation with queries like:
```promql
# Cluster utilization
slurm_cpus_alloc / slurm_cpus_total * 100

# Job queue length
slurm_jobs_pending

# Node availability
slurm_nodes_up / (slurm_nodes_up + slurm_nodes_down) * 100
```

## Security Considerations

- **Service User**: Runs as dedicated `slurm-exporter` user with minimal permissions
- **TLS Encryption**: All metrics collection secured with cluster certificates
- **Access Control**: Only accessible from Prometheus server and authorized administrators
- **File Permissions**: Configuration files secured with appropriate ownership and modes

## Monitoring and Alerting

### Key Metrics to Monitor
- High job queue lengths (pending jobs)
- Node availability and health
- Resource utilization trends
- Job completion rates

### Recommended Alerts
```yaml
# High job queue
- alert: SlurmHighPendingJobs
  expr: slurm_jobs_pending > 50
  
# Node failures
- alert: SlurmNodesDown
  expr: slurm_nodes_down > 0

# Low resource availability
- alert: SlurmLowResources
  expr: slurm_cpus_alloc / slurm_cpus_total > 0.9
```

## Troubleshooting

### Common Issues
1. **Permission Errors**: Ensure slurm-exporter user has access to Slurm commands
2. **Certificate Issues**: Check Step-CA connectivity and certificate renewal
3. **Service Discovery**: Verify target file generation and Prometheus reload
4. **Port Conflicts**: Ensure ports 8080/8443 are available on controller nodes

### Log Analysis
```bash
# Exporter logs
goldentooth command slurm_controller "journalctl -u slurm-exporter -f"

# Certificate renewal logs
goldentooth command slurm_controller "journalctl -u cert-renewer@slurm-exporter -f"
```

## Performance Considerations

- **Scrape Interval**: Default 30 seconds, configurable in Prometheus
- **Resource Usage**: Minimal CPU/memory footprint (~10MB RSS)
- **Network Impact**: HTTP metrics collection over TLS
- **Slurm Load**: Uses read-only Slurm commands with minimal cluster impact

This role provides comprehensive Slurm monitoring capabilities while following goldentooth cluster security and operational patterns.