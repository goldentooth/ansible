# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Ceph CSI test role in the Goldentooth cluster.

## Role Overview

The `test_ceph_csi` role implements comprehensive integration testing for Ceph Container Storage Interface (CSI) deployment following Test-Driven Development (TDD) principles. This role validates the complete storage lifecycle from CSI driver readiness through volume provisioning, mounting, I/O operations, and cleanup.

## TDD Implementation

### RED Phase (Write Failing Tests First)
The role begins by defining test structure and expectations:
- Initialize test results arrays and health tracking variables
- Define test namespace with unique timestamp to avoid conflicts
- Set performance thresholds based on observed cluster performance
- Write tests that initially fail until infrastructure is verified

### GREEN Phase (Make Tests Pass Minimally)
Core functionality validation:
- Verify CSI namespace and pods are running
- Confirm StorageClasses are available and properly configured
- Test basic PVC creation and binding within timeout limits
- Validate pod creation with mounted volumes

### REFACTOR Phase (Improve Coverage and Quality)
Comprehensive testing with advanced scenarios:
- Full volume lifecycle tests (create → bind → mount → use → cleanup)
- Data integrity validation (write → read → verify)
- Performance benchmarking with realistic I/O workloads
- Graceful error handling and cleanup procedures

## Test Architecture

### Infrastructure Layer Tests
- **CSI Namespace**: Confirms `ceph-csi` namespace exists and is accessible
- **CSI Provisioner**: Validates deployment readiness and replica count
- **CSI Node Plugin**: Ensures DaemonSet is running on all cluster nodes
- **StorageClass Validation**: Verifies all three storage classes exist with correct configuration

### Volume Lifecycle Tests
- **PVC Creation**: Creates test PersistentVolumeClaim with Ceph RBD storage
- **PVC Binding**: Waits for Ceph to provision volume and bind within 120 seconds
- **Pod Mounting**: Creates test pod with mounted volume at `/data` path
- **Pod Readiness**: Ensures pod reaches Ready state with volume properly mounted

### Data Operations Tests
- **Write Operations**: Creates test files using shell commands
- **Read Operations**: Reads back test data to verify accessibility
- **Data Integrity**: Compares written vs. read data for corruption detection
- **Filesystem Operations**: Tests `df`, `ls`, permissions, and basic filesystem functions

### Performance Validation Tests
- **Sequential Write**: 100MB write test using `dd` with `fsync` for realistic performance
- **Sequential Read**: Read performance test on written data
- **Performance Thresholds**: Validates against configurable minimum thresholds (default: 50 MB/s)
- **Metrics Export**: Exports actual performance numbers to Prometheus

### Cleanup and Error Handling
- **Resource Cleanup**: Removes all test resources regardless of test outcomes
- **Error Resilience**: Uses `ignore_errors: yes` to prevent cascade failures
- **Graceful Degradation**: Continues cleanup even if individual components fail
- **Debug Information**: Provides detailed error messages for troubleshooting

## Key Variables

### Test Configuration
```yaml
test_namespace: "ceph-csi-test-{{ ansible_date_time.epoch }}"  # Unique test environment
test_pvc_name: "test-pvc-{{ ansible_date_time.epoch }}"        # Unique PVC name
test_pod_name: "test-pod-{{ ansible_date_time.epoch }}"        # Unique pod name
performance_threshold_mb_sec: 50                               # Conservative performance baseline
```

### Test Results Structure
```yaml
ceph_csi_tests: []           # Array of individual test results
ceph_csi_health: false       # Overall health boolean
performance_summary:         # Performance metrics for Prometheus
  write_mb_sec: "68.2"
  read_mb_sec: "74.1"
  threshold_mb_sec: 50
  performance_healthy: true
```

## Integration Patterns

### Prometheus Metrics Export
The role exports comprehensive metrics following Goldentooth patterns:
- `goldentooth_test_success{test="...",category="ceph_csi",node="..."}`: Test pass/fail status
- `goldentooth_test_duration_seconds{test="...",category="ceph_csi",node="..."}`: Test execution time
- `goldentooth_service_health{service="ceph_csi",node="..."}`: Overall service health
- `goldentooth_storage_performance_mb_sec{operation="write|read",storage="ceph_csi",node="..."}`: I/O performance
- `goldentooth_storage_performance_health{storage="ceph_csi",node="..."}`: Performance health indicator

### Test Framework Integration
- Follows standard Goldentooth test role patterns
- Exports results in compatible format for `test_reporter` role
- Integrates with existing Prometheus/Grafana monitoring stack
- Compatible with goldentooth CLI test discovery

### Error Handling Strategy
- All Kubernetes operations use `ignore_errors: yes` to prevent test suite termination
- Cleanup runs regardless of test outcomes to prevent resource leaks
- Detailed error messages and debugging information provided
- Performance metrics recorded even for failed tests when possible

## Performance Baselines

### Expected Performance
Based on cluster testing, typical performance ranges:
- **Sequential Write**: 60-80 MB/s (Pi cluster with NVMe storage)
- **Sequential Read**: 70-90 MB/s (typically faster than writes)
- **Conservative Threshold**: 50 MB/s (allows for system load variations)

### Performance Factors
- Network latency to Ceph monitors (fenn, karstark, lipps)
- Ceph cluster load and replication factor
- Kubernetes node resource availability
- Storage pool configuration (kubernetes vs goldentooth-storage)

## Usage Patterns

### Manual Testing
```bash
# Run Ceph CSI tests specifically
goldentooth test ceph_csi

# Run with increased verbosity for debugging
goldentooth test ceph_csi -vv

# Run as part of storage testing suite
goldentooth test all --tags "storage"
```

### Automated Monitoring
The test integrates with:
- Scheduled cron jobs for regular health checks
- Prometheus alerting on test failures or performance degradation
- Grafana dashboards showing storage performance trends
- CI/CD pipelines for deployment validation

## Troubleshooting Guide

### Common Failure Scenarios

1. **CSI Pods Not Ready**
   - Check ceph-csi namespace: `kubectl get pods -n ceph-csi`
   - Review provisioner logs: `kubectl logs -n ceph-csi -l app=ceph-csi-rbd-provisioner`
   - Verify Ceph cluster health: `ceph status`

2. **PVC Binding Failures**
   - Check StorageClass configuration: `kubectl get sc ceph-rbd -o yaml`
   - Verify Ceph authentication: `ceph auth get client.kubernetes`
   - Monitor provisioner for errors: `kubectl describe pod -n ceph-csi`

3. **Performance Below Threshold**
   - Check Ceph cluster performance: `ceph osd perf`
   - Monitor network connectivity to Ceph monitors
   - Review cluster resource utilization during tests

4. **Pod Mount Failures**
   - Verify node plugin status: `kubectl get ds -n ceph-csi`
   - Check RBD kernel module: `lsmod | grep rbd`
   - Review node plugin logs on affected nodes

### Debugging Commands
```bash
# Check overall test execution
kubectl get events --sort-by='.metadata.creationTimestamp' -n ceph-csi-test-*

# Monitor test pod logs
kubectl logs -f test-pod-* -n ceph-csi-test-*

# Review performance test output
kubectl exec test-pod-* -n ceph-csi-test-* -- df -h /data
```

## Development Guidelines

### Adding New Tests
Follow TDD principles when extending the role:

1. **Write Failing Test**: Define new behavior expectation
2. **Minimal Implementation**: Make test pass with simplest approach
3. **Refactor**: Improve test quality and add error handling

### Performance Threshold Updates
When cluster performance improves:
```yaml
# Update in role defaults or inventory variables
performance_threshold_mb_sec: 70  # New baseline
```

### Test Case Examples
```yaml
# Example new test case structure
- name: Record new functionality test
  set_fact:
    ceph_csi_tests: "{{ ceph_csi_tests + [{'name': 'new_test_name', 'category': 'ceph_csi', 'success': (test_result) | bool, 'duration': 0.5}] }}"
```

This role demonstrates aggressive application of TDD principles to create comprehensive, reliable storage validation that integrates seamlessly with the Goldentooth cluster monitoring infrastructure.