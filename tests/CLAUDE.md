# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Goldentooth cluster testing framework.

## Overview

The `/ansible/tests/` directory contains a comprehensive automated testing framework for the Goldentooth cluster. This framework continuously monitors and validates cluster health across all services and nodes, exporting results as Prometheus metrics for visualization in Grafana.

## Architecture

```
Ansible Test Playbooks → Prometheus Node Exporter → Grafana Dashboard
                      ↓
              Textfile Metrics (/var/lib/prometheus/node-exporter/)
```

The testing system runs Ansible playbooks that execute health checks across the cluster and write results to Prometheus textfile format, which are then scraped by Prometheus and displayed in Grafana.

## Access Methods

**Primary Interface**: Use the `goldentooth` CLI tool for all testing operations:

```bash
# Run all tests
goldentooth test all

# Run specific service tests  
goldentooth test consul
goldentooth test kubernetes
goldentooth test vault
goldentooth test system

# Run quick system checks only
goldentooth test quick
```

**Direct Ansible** (alternative):
```bash
cd /path/to/goldentooth/ansible/tests
ansible-playbook -i ../inventory/hosts playbooks/test_all.yaml
```

## Directory Structure

### `/playbooks/` - Test Orchestration
- `test_all.yaml`: Master playbook that runs all test categories
- `test_step_ca.yaml`: Focused testing for Step-CA certificate authority
- `test_system.yaml`: Quick system resource checks

### `/roles/` - Test Implementation
Individual test roles organized by service category:
- `test_consul/`: Consul cluster health, membership, certificates
- `test_grafana/`: Grafana service availability and configuration
- `test_kubernetes/`: K8s API health, node status, system pods
- `test_prometheus/`: Prometheus service health and data collection
- `test_reporter/`: Metrics aggregation and Prometheus export
- `test_step_ca/`: Certificate authority health and certificate status
- `test_storage/`: NFS mounts, ZFS pools, storage availability
- `test_system_resources/`: CPU, memory, disk, load average checks
- `test_vault/`: Vault service status, seal state, authentication

### `/scripts/` - Automation
- `run_tests.sh`: Direct script runner for test playbooks
- `setup_cron.sh`: Install and configure automated test scheduling

### `/templates/` - Metric Templates
- `goldentooth_metrics.prom.j2`: Jinja2 template for Prometheus textfile format

## Test Categories and Metrics

### System Resources
- **CPU Usage**: Load average and CPU utilization per node
- **Memory**: Available memory and swap usage
- **Disk**: Filesystem usage and available space
- **Network**: Basic connectivity checks

**Metrics**: `goldentooth_node_resource_usage{resource,node}`

### Service Health
- **Consul**: Cluster membership, service registration, certificate validity
- **Kubernetes**: API server health, node readiness, pod status
- **Vault**: Service availability, seal status, authentication
- **Storage**: Mount point availability, ZFS pool health

**Metrics**: `goldentooth_service_health{service,node}`

### Certificate Management
- **Expiration Tracking**: Days until certificate expiry across all services
- **CA Health**: Step-CA availability and certificate chain validity
- **Automated Renewal**: Certificate rotation status

**Metrics**: `goldentooth_certificate_expiry_days{service,node}`

### Test Execution
- **Success/Failure**: Individual test pass/fail status
- **Duration**: Test execution time for performance monitoring
- **Coverage**: Test completion across all nodes and services

**Metrics**: 
- `goldentooth_test_success{test,category,node}`
- `goldentooth_test_duration_seconds{test,category,node}`

## Configuration Files

### `ansible.cfg`
Local Ansible configuration for the test environment:
- Host key checking disabled for cluster nodes
- Optimized connection settings
- Test-specific logging configuration

### `group_vars/`
Test-specific variable overrides and configuration separate from main cluster configuration.

## Automated Testing

### Cron Integration
```bash
# Setup automated testing (typically every 15 minutes)
./scripts/setup_cron.sh
```

### Monitoring Integration
- Results exported to `/var/lib/prometheus/node-exporter/goldentooth_tests.prom`
- Prometheus scrapes textfiles automatically via node exporter
- Grafana dashboard provides visual cluster health overview

## Development Guidelines

### Adding New Tests
1. Create new role in `roles/test_<service>/`
2. Follow existing patterns for consistent metric export
3. Ensure role sets these standard variables:
   - `test_results`: List of individual test outcomes
   - `service_health`: Overall service health (0/1)
   - `certificate_status`: Certificate expiration information

### Test Result Format
```yaml
test_results:
  - name: "descriptive_test_name"
    category: "service_category" 
    success: true|false
    duration: 0.5  # execution time in seconds
```

### Best Practices
- Keep tests lightweight and non-invasive
- Focus on health indicators, not deep diagnostics
- Export meaningful metrics for alerting
- Maintain consistent naming conventions
- Document test purposes and expected outcomes

## Troubleshooting

### Common Issues
- **Tests not executing**: Check `goldentooth ping all` for connectivity
- **Missing metrics**: Verify node exporter textfile directory permissions
- **Dashboard not updating**: Check Prometheus target health and scrape intervals

### Debugging Commands
```bash
# Verify test playbook syntax
ansible-playbook --syntax-check playbooks/test_all.yaml

# Check metric export
cat /var/lib/prometheus/node-exporter/goldentooth_tests.prom

# Manual test execution with verbose output
goldentooth test all -v
```

This testing framework is essential for maintaining cluster reliability and provides early warning of service degradation or configuration drift.