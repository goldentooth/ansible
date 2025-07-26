# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_ceph_csi role.

## Overview

This role deploys and manages Ceph CSI (Container Storage Interface) driver to provide persistent storage for Kubernetes workloads using the existing Goldentooth Ceph cluster.

## Purpose

- Deploy Ceph CSI RBD (RADOS Block Device) driver on Kubernetes
- Configure StorageClasses for different use cases
- Set up authentication between Kubernetes and Ceph cluster
- Provide block storage integration for Pi-optimized workloads
- Enable persistent volume provisioning and management

## Files

- `tasks/main.yaml`: Main deployment tasks
- `templates/`: Kubernetes manifest templates
- `defaults/main.yaml`: Default configuration variables
- `handlers/main.yaml`: Service restart handlers

## Key Features

### CSI Driver Deployment
- RBD CSI driver v3.11.0 with ARM64 support
- Provisioner deployment for volume management
- Node plugin DaemonSet for all worker nodes
- Pi-optimized resource limits and requests

### Storage Classes
- **ceph-rbd**: Default storage class with Delete reclaim policy
- **ceph-rbd-retain**: Storage class with Retain reclaim policy
- **ceph-rbd-fast**: Fast storage using goldentooth-storage pool

### Performance Optimization
- ARM64-compatible container images
- Memory limits optimized for 8GB Pi nodes
- Resource requests tuned for Pi ARM cores
- Filesystem optimizations (ext4 with appropriate features)

### Security Integration
- Ceph authentication via client.kubernetes user
- Kubernetes RBAC for CSI operations
- Encrypted secret management
- Integration with cluster certificate management

## Dependencies

- Requires existing Ceph cluster (fenn, karstark, lipps nodes)
- Depends on functional Kubernetes cluster
- Needs network connectivity between K8s and Ceph nodes
- Uses existing goldentooth CLI for Ceph operations

## Variables

Key variables from inventory:
- `ceph.cluster_id`: Ceph cluster identifier (default: goldentooth-ceph)
- `ceph.monitors`: List of Ceph monitor addresses
- `ceph.pools.kubernetes`: Main storage pool name
- `ceph.pools.fast`: Fast storage pool name
- `kubernetes.namespace.ceph_csi`: CSI namespace (default: ceph-csi)

## Usage

Deploy via Ansible playbook:
```yaml
- { role: 'goldentooth.setup_ceph_csi' }
```

Available via goldentooth CLI:
```bash
goldentooth setup_ceph_csi
```

## Integration Points

### Ceph Cluster Integration
- Uses existing cephadm-managed Ceph cluster
- Leverages kubernetes and goldentooth-storage pools
- Integrates with Ceph monitor quorum (fenn, karstark, lipps)

### Kubernetes Integration
- Deploys to dedicated ceph-csi namespace
- Provides default StorageClass for automatic provisioning
- Supports volume expansion and snapshot operations

### Monitoring Integration
- CSI metrics exposed for Prometheus scraping
- Health checks via liveness probes
- Integration with existing observability stack

## Operational Features

### Authentication Management
- Automatic Ceph client.kubernetes user creation
- Kubernetes Secret population with Ceph keys
- Secure key distribution to CSI components

### Storage Management
- Dynamic volume provisioning
- Volume expansion support
- Multiple reclaim policies (Delete/Retain)
- Pool-based storage classes for different performance needs

### Troubleshooting Support
- Comprehensive logging configuration
- Test pod deployment for verification
- Health check endpoints
- Integration with cluster monitoring

## Pi-Specific Optimizations

### Resource Management
- Memory limits: 1Gi for RBD plugin, 512Mi for sidecars
- CPU requests optimized for ARM64 performance
- Appropriate scheduling constraints for mixed architecture

### Storage Configuration
- ext4 filesystem with Pi-optimized features
- Block size and I/O patterns tuned for USB SSDs
- Image features optimized for Pi storage characteristics

### Network Optimization
- Efficient communication with Ceph monitors
- Minimal protocol overhead
- Optimized for Pi Ethernet performance

## Security Considerations

- Ceph authentication with minimal required permissions
- Kubernetes RBAC following principle of least privilege
- Encrypted communication between components
- Secure secret management practices
- Integration with cluster's certificate management

## Testing and Validation

The role includes test resources for validation:
- Test PVC creation and binding
- File I/O performance testing
- Data integrity verification
- Multi-container storage access testing

## Common Operations

### Deployment
```bash
goldentooth setup_ceph_csi
```

### Testing
```bash
# From ceph-csi directory
./test.sh
```

### Key Management
```bash
# Update Ceph authentication keys
./setup-ceph-keys.sh
```

### Monitoring
```bash
# Check CSI pod status
kubectl get pods -n ceph-csi

# View storage classes
kubectl get storageclass

# Monitor volume operations
kubectl get pv,pvc --all-namespaces
```

This role bridges the gap between Goldentooth's distributed Ceph storage and Kubernetes workload requirements, providing reliable persistent storage optimized for Raspberry Pi cluster constraints.