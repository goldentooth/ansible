# Goldentooth Cluster Health Tests

This directory contains the automated testing framework for the Goldentooth cluster, designed to continuously monitor and validate cluster health.

## Overview

The test framework uses Ansible to run health checks across all cluster services and exports results as Prometheus metrics, which are then visualized in Grafana.

## Architecture

```
Tests (Ansible) → Prometheus Metrics → Grafana Dashboard
                ↓
        Node Exporter Textfile
    (/var/lib/prometheus/node-exporter/)
```

## Quick Start

### Running Tests Manually

```bash
# Run all tests
goldentooth test all

# Run specific service tests
goldentooth test consul
goldentooth test kubernetes
goldentooth test vault

# Run quick system checks only
goldentooth test quick
```

### Setting Up Automated Testing

```bash
# Review and install cron entries
./scripts/setup_cron.sh
```

## Test Categories

- **System**: CPU, memory, disk usage, load average
- **Consul**: Service health, member count, certificates
- **Kubernetes**: Node status, API health, system pods
- **Vault**: Service status, seal state, certificates
- **Storage**: NFS mounts, ZFS pools, Ceph status
- **Observability**: Prometheus, Grafana, Loki health

## Metrics Exported

### Service Health
- `goldentooth_service_health{service,node}` - Overall service health (1=healthy, 0=unhealthy)

### Test Results
- `goldentooth_test_success{test,category,node}` - Individual test pass/fail
- `goldentooth_test_duration_seconds{test,category,node}` - Test execution time

### Certificates
- `goldentooth_certificate_expiry_days{service,node}` - Days until certificate expiry

### Cluster Membership
- `goldentooth_cluster_member_count{service}` - Number of active cluster members

### Resources
- `goldentooth_node_resource_usage{resource,node}` - CPU/memory/disk usage percentage

## Grafana Dashboard

Import the dashboard from `grafana-dashboard.json`:

1. Open Grafana UI
2. Go to Dashboards → Import
3. Upload `grafana-dashboard.json`
4. Select your Prometheus data source

## Adding New Tests

1. Create a new role in `roles/test_<service>/`
2. Follow the pattern in existing test roles
3. Ensure the role exports results to the standard variables:
   - `test_results` - List of test results
   - `service_health` - Overall service health
   - `certificate_status` - Certificate expiration info

## Test Result Format

Each test should produce results in this format:
```yaml
test_results:
  - name: "descriptive_test_name"
    category: "service_category"
    success: true|false
    duration: 0.5  # seconds
```

## Troubleshooting

### Tests Not Running
- Check ansible connectivity: `goldentooth ping all`
- Verify test playbook syntax: `ansible-playbook --syntax-check playbooks/test_all.yaml`

### Metrics Not Appearing
- Check node exporter directory permissions
- Verify Prometheus is scraping textfiles
- Look for `.prom` files in `/var/lib/prometheus/node-exporter/`

### Dashboard Not Updating
- Check Prometheus targets page for node exporters
- Verify time range in Grafana
- Check for failed scrapes in Prometheus