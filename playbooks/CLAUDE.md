# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Goldentooth cluster test playbooks.

## Overview

The `/ansible/tests/playbooks/` directory contains orchestration playbooks that coordinate test execution across the Goldentooth cluster. These playbooks manage test role execution, result aggregation, and metric export to Prometheus.

## Playbook Architecture

Test playbooks follow a consistent pattern:
1. **Preparation**: Set up test environment and variables
2. **Execution**: Run test roles in appropriate order
3. **Aggregation**: Collect and format results
4. **Export**: Write metrics to Prometheus textfile format
5. **Reporting**: Optional result summary and notifications

## Primary Playbooks

### `test_all.yaml` - Comprehensive Cluster Testing

**Purpose**: Execute complete cluster health validation across all services and nodes

**Execution Flow**:
```yaml
1. System resource checks (CPU, memory, disk)
2. Storage system validation (NFS, ZFS)
3. Core infrastructure services (Consul, Vault)
4. Container orchestration (Kubernetes, Nomad)
5. Observability stack (Prometheus, Grafana, Loki)
6. Certificate authority and PKI health
7. Result aggregation and metric export
```

**Usage**:
```bash
# Via goldentooth CLI (recommended)
goldentooth test all

# Direct Ansible execution
ansible-playbook -i ../inventory/hosts test_all.yaml
```

**Key Features**:
- Comprehensive coverage of all cluster services
- Parallel execution where safe (using `serial` and `strategy`)
- Detailed timing and performance metrics
- Automatic failure isolation (continues testing other services)
- Results exported to `/var/lib/prometheus/node-exporter/goldentooth_tests.prom`

### `test_system.yaml` - Quick System Health

**Purpose**: Fast system resource and connectivity checks for rapid status assessment

**Execution Flow**:
```yaml
1. Basic connectivity (ping, SSH)
2. System load and resource utilization
3. Critical filesystem availability
4. Network interface status
5. Essential service process checks
```

**Usage**:
```bash
# Via goldentooth CLI
goldentooth test quick

# Direct execution
ansible-playbook -i ../inventory/hosts test_system.yaml
```

**Optimization**:
- Designed for sub-30 second execution
- Minimal external dependencies
- Focuses on critical system indicators
- Suitable for frequent automated runs

### `test_step_ca.yaml` - Certificate Authority Focus

**Purpose**: Detailed testing of Step-CA certificate authority and PKI infrastructure

**Execution Flow**:
```yaml
1. Step-CA service availability
2. Root and intermediate certificate validation
3. Certificate expiration monitoring
4. Automatic renewal system health
5. Certificate distribution verification
6. Client certificate authentication testing
```

**Usage**:
```bash
# Via goldentooth CLI
goldentooth test step_ca

# Direct execution  
ansible-playbook -i ../inventory/hosts test_step_ca.yaml
```

**Certificate Testing Scope**:
- **Root CA**: Certificate chain validation and trust
- **Intermediate CA**: Signing capability and expiration
- **Service Certificates**: Consul, Vault, Kubernetes, etc.
- **Client Certificates**: SSH CA, user authentication
- **Renewal Status**: Systemd timer health and execution

## Playbook Patterns

### Variable Management
```yaml
vars:
  test_start_time: "{{ ansible_date_time.epoch }}"
  test_categories:
    - system
    - storage  
    - consul
    - kubernetes
    - vault
  
# Results aggregation
pre_tasks:
  - name: Initialize test results
    ansible.builtin.set_fact:
      all_test_results: []
      service_health_summary: {}
```

### Role Execution Pattern
```yaml
# Standard role invocation with error handling
- name: "Run {{ service }} health tests"
  ansible.builtin.include_role:
    name: "test_{{ service }}"
  rescue:
    - name: "Mark {{ service }} tests as failed"
      ansible.builtin.set_fact:
        service_health_summary: "{{ service_health_summary | combine({service: 0}) }}"
```

### Result Aggregation
```yaml
post_tasks:
  - name: "Aggregate test results"
    ansible.builtin.include_role:
      name: test_reporter
    vars:
      collected_results: "{{ all_test_results }}"
      test_execution_time: "{{ ansible_date_time.epoch | int - test_start_time | int }}"
```

## Execution Strategies

### Parallel Execution
For independent tests that can run simultaneously:
```yaml
strategy: free
serial: "{{ groups['all'] | length }}"
```

### Sequential Execution  
For tests with dependencies or resource constraints:
```yaml
strategy: linear
serial: 1
```

### Targeted Execution
Run tests on specific host groups:
```bash
# Test only control plane nodes
ansible-playbook test_all.yaml --limit consul_server

# Test specific services
ansible-playbook test_all.yaml --tags "consul,vault"
```

## Integration Points

### Goldentooth CLI Mapping
Each playbook maps to specific CLI commands:
```bash
goldentooth test all      -> test_all.yaml
goldentooth test quick    -> test_system.yaml  
goldentooth test step_ca  -> test_step_ca.yaml
goldentooth test consul   -> test_all.yaml --tags consul
```

### Automation Integration
```bash
# Cron automation via setup script
./scripts/setup_cron.sh

# Systemd timer integration (alternative)
systemctl enable --now goldentooth-tests.timer
```

### Monitoring Integration
- **Prometheus**: Automatic metric collection from textfiles
- **Grafana**: Dashboard visualization of test results
- **Alerting**: Prometheus AlertManager rules based on test failures

## Development Guidelines

### Adding New Test Playbooks

1. **Follow Naming Convention**: `test_<category>.yaml`
2. **Include Standard Variables**: Test timing, categories, results
3. **Implement Error Handling**: Graceful failure and recovery
4. **Export Metrics**: Consistent format for Prometheus consumption
5. **Document Integration**: Update CLI and cron configurations

### Best Practices

#### Performance Optimization
- Use `gather_facts: false` when facts aren't needed
- Implement conditional execution for expensive tests
- Consider `async` execution for long-running checks
- Use `changed_when: false` for read-only operations

#### Error Handling
```yaml
# Graceful error handling pattern
block:
  - name: "Execute test sequence"
    # Test implementation
rescue:
  - name: "Log test failure"
    ansible.builtin.debug:
      msg: "Test failed: {{ ansible_failed_result.msg }}"
  - name: "Continue with other tests"
    ansible.builtin.meta: clear_host_errors
```

#### Result Consistency
Ensure all playbooks export results in the standard format:
```yaml
goldentooth_test_success{test,category,node} = 0|1
goldentooth_test_duration_seconds{test,category,node} = float
goldentooth_service_health{service,node} = 0|1
```

### Debugging and Troubleshooting

#### Verbose Execution
```bash
# Detailed output for debugging
goldentooth test all -v

# Ansible verbose levels
ansible-playbook test_all.yaml -vvv
```

#### Manual Result Inspection
```bash
# Check exported metrics
cat /var/lib/prometheus/node-exporter/goldentooth_tests.prom

# Verify Prometheus scraping
curl http://localhost:9090/api/v1/query?query=goldentooth_test_success
```

#### Common Issues
- **Permission errors**: Check node exporter textfile directory
- **Timeout failures**: Adjust test timeout values in role defaults
- **Network connectivity**: Verify SSH access and firewall rules

This playbook structure provides flexible, maintainable test orchestration while supporting both automated monitoring and manual troubleshooting workflows.