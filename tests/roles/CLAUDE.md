# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Goldentooth cluster test roles.

## Overview

The `/ansible/tests/roles/` directory contains specialized Ansible roles for testing and monitoring the health of various services in the Goldentooth cluster. Each role follows a consistent pattern for executing health checks and exporting results as Prometheus metrics.

## Test Role Architecture

All test roles follow this standard structure:
```
test_<service>/
├── tasks/
│   └── main.yaml          # Health check implementation
├── vars/
│   └── main.yaml          # Service-specific variables (optional)
└── templates/
    └── metrics.prom.j2    # Metric export template (optional)
```

## Role Categories

### Core Infrastructure Tests

#### `test_system_resources/`
**Purpose**: Monitor system resource utilization across all cluster nodes
**Checks**:
- CPU load average and utilization
- Memory usage and availability  
- Disk space and filesystem health
- Basic network connectivity

**Key Metrics**:
- `goldentooth_node_resource_usage{resource="cpu|memory|disk",node}`
- `goldentooth_system_load{node}`

#### `test_storage/`
**Purpose**: Validate storage systems and mount points
**Checks**:
- NFS mount availability and read/write access
- ZFS pool health and available space
- Ceph cluster status (if configured)
- Filesystem permissions and ownership

**Key Metrics**:
- `goldentooth_storage_mount_available{mount,node}`
- `goldentooth_zfs_pool_health{pool,node}`

### Service-Specific Tests

#### `test_consul/`
**Purpose**: Monitor Consul cluster health and service discovery
**Checks**:
- Consul agent status and cluster membership
- Service registration and health checks
- Certificate validity and rotation status
- KV store accessibility

**Key Metrics**:
- `goldentooth_consul_members{datacenter}`
- `goldentooth_consul_service_health{service,node}`

#### `test_vault/`
**Purpose**: Validate Vault security and availability
**Checks**:
- Vault service status and API accessibility
- Seal state and cluster leadership
- Authentication method availability
- Certificate expiration monitoring

**Key Metrics**:
- `goldentooth_vault_sealed{node}`
- `goldentooth_vault_auth_method_available{method,node}`

#### `test_kubernetes/`
**Purpose**: Monitor Kubernetes cluster health
**Checks**:
- API server availability and response time
- Node readiness and resource allocation
- System pod status (kube-system namespace)
- Control plane component health

**Key Metrics**:
- `goldentooth_k8s_node_ready{node}`
- `goldentooth_k8s_api_response_time{endpoint}`

#### `test_step_ca/`
**Purpose**: Monitor Step-CA certificate authority
**Checks**:
- CA service availability
- Certificate chain validity
- Automatic renewal status
- Root and intermediate certificate health

**Key Metrics**:
- `goldentooth_step_ca_available{node}`
- `goldentooth_certificate_expiry_days{service,node}`

### Observability Tests

#### `test_prometheus/`
**Purpose**: Monitor Prometheus data collection and scraping
**Checks**:
- Prometheus service availability
- Target discovery and scrape success
- Rule evaluation and alerting
- Data retention and storage health

**Key Metrics**:
- `goldentooth_prometheus_targets_up{job}`
- `goldentooth_prometheus_scrape_success{instance}`

#### `test_grafana/`
**Purpose**: Validate Grafana dashboard and visualization service
**Checks**:
- Grafana service availability and login
- Dashboard loading and data source connectivity
- User authentication and authorization
- Plugin availability and configuration

**Key Metrics**:
- `goldentooth_grafana_available{node}`
- `goldentooth_grafana_datasource_health{datasource}`

### Utility Roles

#### `test_reporter/`
**Purpose**: Aggregate and export test results to Prometheus
**Function**:
- Collect results from all test roles
- Format metrics in Prometheus textfile format
- Write to node exporter textfile directory
- Handle metric cleanup and rotation

**Output**: `/var/lib/prometheus/node-exporter/goldentooth_tests.prom`

## Standard Role Patterns

### Task Structure
All test roles should follow this pattern in `tasks/main.yaml`:

```yaml
---
# Service-specific health checks
- name: "Check service status"
  # Implementation specific to service
  
- name: "Set test results"
  ansible.builtin.set_fact:
    test_results: "{{ test_results | default([]) + [result] }}"
    service_health: "{{ 1 if service_healthy else 0 }}"
    
- name: "Export certificate status" 
  ansible.builtin.set_fact:
    certificate_status:
      expiry_days: "{{ cert_expiry_days }}"
      valid: "{{ cert_valid }}"
```

### Variable Standards
Each role should export these standardized variables:

```yaml
# Individual test results
test_results:
  - name: "descriptive_test_name"
    category: "service_category"
    success: true|false
    duration: 0.5  # seconds
    message: "Optional details"

# Overall service health (0 = unhealthy, 1 = healthy)
service_health: 1

# Certificate information (when applicable)
certificate_status:
  expiry_days: 30
  valid: true
  subject: "CN=service.cluster.local"
```

## Development Guidelines

### Adding New Test Roles

1. **Create Role Structure**:
   ```bash
   mkdir -p test_<service>/{tasks,vars,templates}
   ```

2. **Implement Health Checks**:
   - Focus on critical service indicators
   - Keep checks lightweight and non-invasive
   - Handle failures gracefully
   - Export meaningful metrics

3. **Follow Naming Conventions**:
   - Role name: `test_<service>`
   - Metric prefix: `goldentooth_<service>`
   - Test categories: match service names

4. **Integration Requirements**:
   - Export to standard variables
   - Support both individual and aggregated runs
   - Handle missing services gracefully

### Testing Patterns

#### Quick vs. Comprehensive Tests
- **Quick tests**: Basic availability and response checks
- **Comprehensive tests**: Deep health validation and performance metrics
- **Critical tests**: Essential services that affect cluster operation

#### Error Handling
```yaml
- name: "Service health check"
  block:
    # Health check implementation
  rescue:
    - name: "Mark service as unhealthy"
      ansible.builtin.set_fact:
        service_health: 0
        test_results: "{{ test_results + [failed_result] }}"
```

### Metric Guidelines

- **Naming**: Use consistent prefixes and labels
- **Labels**: Include `node`, `service`, `category` where relevant
- **Values**: Use 0/1 for boolean health, actual values for measurements
- **Documentation**: Include metric descriptions in role documentation

## Integration with Main Cluster

### Playbook Integration
Test roles are called from main test playbooks:
- `test_all.yaml`: Runs all test categories
- Service-specific playbooks: Run focused test suites

### Goldentooth CLI Integration
```bash
# Map to goldentooth CLI commands
goldentooth test consul     -> roles/test_consul
goldentooth test kubernetes -> roles/test_kubernetes
goldentooth test all        -> all test roles
```

### Monitoring Integration
- Results automatically exported to Prometheus
- Grafana dashboards consume test metrics
- Alerting rules can be based on test results

This role-based testing architecture provides comprehensive cluster health monitoring while maintaining modularity and extensibility for new services.