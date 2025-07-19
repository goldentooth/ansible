# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_ceph role.

## Overview

This role sets up Ceph distributed storage system optimized for Raspberry Pi cluster constraints with automated management, monitoring integration, and performance tuning.

## Purpose

- Configure Ceph distributed storage on Pi cluster
- Set up Ceph monitors, managers, and OSDs
- Optimize Ceph for low-memory Pi hardware
- Integrate with existing certificate management
- Configure Ceph pools for cluster workloads
- Prepare for Kubernetes CSI integration

## Files

- `tasks/main.yaml`: Main task file
- `templates/ceph.conf.j2`: Ceph configuration template
- `templates/cert-renewer@ceph.conf.j2`: Certificate renewal configuration
- `handlers/main.yaml`: Service restart and configuration handlers

## Key Features

### Lightweight Ceph Deployment
- Optimized for 3-node cluster (fenn, karstark, lipps)
- Minimal resource footprint for Pi constraints
- Single OSD per node using 450-500GB SSDs
- Memory usage tuned for 8GB Pi systems

### Service Architecture
- **Monitors**: All 3 nodes for quorum (minimal overhead)
- **Managers**: 2 nodes (fenn, karstark) for redundancy
- **OSDs**: 1 per node on attached SSDs
- **MDS/RGW**: Not deployed initially (CephFS/S3 not needed)

### Performance Optimization
- OSD memory target reduced from 4GB to 1GB
- Optimized for USB 3.0 SSD performance characteristics
- Simple replication strategy (size=2, min_size=1)
- Tuned for Pi ARM64 architecture

### Certificate Management
- Integrates with Step-CA for TLS certificates
- Automated certificate renewal via systemd timers
- Follows cluster's certificate management patterns

### Monitoring Integration
- Ceph metrics exposed for Prometheus scraping
- Health checks via Consul service registry
- Dashboard integration with existing Grafana

## Dependencies

- Requires storage devices attached to ceph group nodes
- Depends on Step-CA for certificate management
- Uses Consul for service discovery
- Integrates with existing monitoring stack

## Variables

Key variables from inventory:
- `ceph.cluster_name`: Ceph cluster identifier
- `ceph.public_network`: Network CIDR for cluster communication
- `ceph.osd_memory_target`: Memory limit per OSD (default: 1GB)
- `ceph.pool_size`: Replication factor (default: 2)
- `ceph.pool_min_size`: Minimum replicas (default: 1)

## Usage

This role is typically called via the setup_ceph playbook:
```yaml
- { role: 'goldentooth.setup_ceph' }
```

Available via goldentooth CLI:
```bash
goldentooth setup_ceph
```

## Integration

Works with:
- `goldentooth.setup_consul`: Service registration
- `goldentooth.bootstrap_cluster_ca`: Certificate management
- `goldentooth.setup_prometheus`: Metrics collection
- Kubernetes CSI drivers (future integration)

## Pi-Specific Optimizations

### Memory Management
- Reduced default memory allocations
- OSD memory target: 1GB (vs 4GB default)
- Monitor memory limit: 512MB
- Manager memory limit: 512MB

### Storage Configuration
- Optimized for single SSD per node
- Tuned for USB 3.0 performance characteristics
- Simple CRUSH map for 3-node topology

### Network Optimization
- Single network configuration (no separate cluster network)
- Optimized for Pi Ethernet performance
- Minimal protocol overhead

## Security Considerations

- TLS encryption for all inter-node communication
- Proper authentication keys generated securely
- Integration with cluster's certificate management
- Service-specific Consul ACL policies
- Restricted file permissions on configuration files

## Operational Notes

- Cluster requires at least 2 of 3 nodes for operations
- Graceful degradation with single node failure
- Automatic recovery when failed nodes return
- Regular health monitoring via existing observability stack