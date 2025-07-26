# Ceph CSI Integration Test Role

## Overview

The `test_ceph_csi` role provides comprehensive integration testing for Ceph CSI (Container Storage Interface) deployment in the Goldentooth Kubernetes cluster. This test suite follows Test-Driven Development (TDD) principles using the RED-GREEN-REFACTOR methodology to ensure robust and reliable storage validation.

## Test Philosophy

### RED-GREEN-REFACTOR Cycle

1. **RED Phase**: Write failing tests that define expected behavior
   - Define test structure and expectations
   - Establish clear success criteria
   - Test CSI infrastructure components

2. **GREEN Phase**: Make tests pass with minimal implementation
   - Verify StorageClasses are available
   - Validate basic CSI driver functionality
   - Ensure pods can be created and scheduled

3. **REFACTOR Phase**: Improve test coverage and code quality
   - Add comprehensive volume lifecycle tests
   - Include performance validation
   - Implement data integrity checks
   - Add proper cleanup procedures

## Test Categories

### Infrastructure Tests
- **CSI Namespace**: Verify `ceph-csi` namespace exists and is accessible
- **CSI Provisioner**: Validate provisioner deployment is ready and healthy
- **CSI Node Plugin**: Ensure DaemonSet is running on all cluster nodes
- **StorageClasses**: Confirm all three Ceph RBD storage classes exist:
  - `ceph-rbd` (default)
  - `ceph-rbd-retain` (retain policy)
  - `ceph-rbd-fast` (fast storage pool)

### Volume Lifecycle Tests
- **PVC Creation**: Create 1GB test PersistentVolumeClaim
- **PVC Binding**: Verify PVC binds to Ceph RBD volume within 120 seconds
- **Pod Mounting**: Create test pod with mounted Ceph volume
- **Pod Readiness**: Ensure pod becomes ready with volume mounted at `/data`

### Data Operations Tests
- **Write Operations**: Test basic file creation and write operations
- **Read Operations**: Verify data can be read back correctly
- **Data Integrity**: Confirm written data matches read data
- **Filesystem Operations**: Test `df`, `ls`, file permissions, and basic filesystem functions

### Performance Validation
- **Sequential Write**: 100MB write test with `dd` and `fsync`
- **Sequential Read**: Read performance test with 100MB file
- **Performance Thresholds**: Validate performance meets minimum 50 MB/s (conservative threshold)
- **Metrics Export**: Export actual performance metrics to Prometheus

### Cleanup and Resource Management
- **Pod Cleanup**: Remove test pods cleanly
- **PVC Cleanup**: Delete test PVCs and associated storage
- **Namespace Cleanup**: Remove test namespace and all resources
- **Error Handling**: Graceful cleanup even if tests fail

## Key Features

### Performance Monitoring
- Measures actual I/O performance using realistic workloads
- Exports performance metrics to Prometheus for trending
- Validates against configurable performance thresholds
- Based on observed cluster performance (~70 MB/s sequential)

### Error Resilience
- All operations use `ignore_errors: yes` to prevent test cascade failures
- Comprehensive cleanup runs regardless of test outcomes
- Detailed error reporting and debugging information
- Graceful handling of missing components

### Integration with Goldentooth Framework
- Follows standard test role patterns used throughout the cluster
- Exports results in standardized format for aggregation
- Integrates with Prometheus metrics collection
- Compatible with existing Grafana dashboards

## Usage

### Via Goldentooth CLI
```bash
# Run all Ceph CSI tests
goldentooth test ceph_csi

# Run with specific tags
goldentooth test ceph_csi --tags "storage,integration"

# Run with verbose output
goldentooth test ceph_csi -vv
```

### Via Ansible Directly
```bash
cd /path/to/goldentooth/ansible/tests
ansible-playbook playbooks/test_ceph_csi.yaml
```

### As Part of Full Test Suite
```bash
# Ceph CSI tests are included in the full test suite
goldentooth test all --tags "storage"
```

## Test Configuration

### Default Variables
- **Test Namespace**: `ceph-csi-test-{timestamp}`
- **PVC Size**: 1GB (adequate for testing without waste)
- **Performance Threshold**: 50 MB/s (conservative baseline)
- **Timeout Values**:
  - PVC Binding: 120 seconds
  - Pod Ready: 180 seconds
  - Kubernetes operations: 5-10 seconds

### Customization
Performance thresholds and timeouts can be adjusted by overriding variables:

```yaml
performance_threshold_mb_sec: 70  # Increase threshold
pvc_bind_timeout: 180            # Longer binding timeout
pod_ready_timeout: 300           # Longer pod startup timeout
```

## Expected Outputs

### Successful Test Run
```
CEPH CSI TEST SUMMARY
═══════════════════════════════════════════════════════════════════════
Overall Health: ✅ HEALTHY
Total Tests: 17
Passed: 17
Failed: 0

Performance Results:
- Write Speed: 68.2 MB/s (✅ >= 50 MB/s)
- Read Speed: 74.1 MB/s (✅ >= 50 MB/s)
═══════════════════════════════════════════════════════════════════════
```

### Prometheus Metrics
The test exports comprehensive metrics:

```prometheus
# Test success/failure metrics
goldentooth_test_success{test="csi_provisioner_ready",category="ceph_csi",node="allyrion"} 1

# Performance metrics
goldentooth_storage_performance_mb_sec{operation="write",storage="ceph_csi",node="allyrion"} 68.2
goldentooth_storage_performance_mb_sec{operation="read",storage="ceph_csi",node="allyrion"} 74.1

# Health indicators
goldentooth_service_health{service="ceph_csi",node="allyrion"} 1
goldentooth_storage_performance_health{storage="ceph_csi",node="allyrion"} 1
```

## Troubleshooting

### Common Issues

1. **PVC Binding Failures**
   - Check Ceph cluster health: `ceph status`
   - Verify CSI pods are running: `kubectl get pods -n ceph-csi`
   - Review provisioner logs: `kubectl logs -n ceph-csi -l app=ceph-csi-rbd-provisioner`

2. **Performance Below Threshold**
   - Check network connectivity to Ceph monitors
   - Verify Ceph cluster performance with `ceph osd perf`
   - Monitor cluster load during testing

3. **Pod Mount Failures**
   - Check node plugin status: `kubectl get ds -n ceph-csi ceph-csi-rbd-nodeplugin`
   - Review node plugin logs on affected nodes
   - Verify RBD kernel module is loaded: `lsmod | grep rbd`

### Debug Mode
Run tests with increased verbosity for detailed debugging:

```bash
goldentooth test ceph_csi -vvv --tags "ceph_csi"
```

## Integration Points

### Monitoring Integration
- Test results appear in Grafana dashboards
- Performance trends tracked over time
- Alerting based on test failures or performance degradation

### CI/CD Integration
- Suitable for automated testing pipelines
- Exit codes reflect overall test success/failure
- JSON reports available for automated processing

### Cluster Health Monitoring
- Integrated with overall cluster health checks
- Part of comprehensive infrastructure validation
- Supports both quick checks and deep integration tests

## Maintenance

### Updating Performance Thresholds
As the cluster evolves or hardware improves, update thresholds in the role defaults:

```yaml
# In ansible/tests/roles/test_ceph_csi/defaults/main.yaml
performance_threshold_mb_sec: 80  # New baseline
```

### Adding New Test Cases
Follow TDD principles when adding tests:

1. Write a failing test that defines new behavior
2. Implement minimal code to make the test pass
3. Refactor to improve code quality and coverage

### Regular Maintenance
- Review test performance trends monthly
- Update container images and test patterns as needed
- Validate test effectiveness against real-world issues