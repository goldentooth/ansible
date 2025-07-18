# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the inventory directory.

## Overview

This directory contains the Ansible inventory configuration for the goldentooth cluster, defining hosts, groups, and variables that control cluster behavior.

## Structure

- `hosts`: Main inventory file defining all nodes and their group memberships
- `group_vars/all/vars.yaml`: Global variables shared across all hosts
- `group_vars/all/vault`: Encrypted secrets and sensitive configuration
- `host_vars/`: Individual host-specific variable files

## Host Groups

### Infrastructure Groups
- `all_nodes`: All cluster nodes
- `all_pis`: All Raspberry Pi nodes (12 nodes: allyrion through lipps)
- `all_non_pis`: Non-Pi nodes (velaryon - x86 GPU system)

### Service Groups
- `k8s_cluster`: Kubernetes cluster nodes
  - `k8s_control_plane`: Control plane nodes (bettley, cargyll, dalt)
  - `k8s_worker`: Worker nodes including GPU workers
- `consul`: Consul service mesh nodes
  - `consul_server`: Consul servers (same as k8s control plane)
  - `consul_client`: Consul clients (all other nodes)
- `nomad`: Nomad workload orchestration
  - `nomad_server`: Nomad servers (same as k8s control plane)
  - `nomad_client`: Nomad clients with GPU classification
- `vault`: HashiCorp Vault nodes (bettley, cargyll, dalt)

### Specialized Services
- `step_ca`: Certificate Authority (jast)
- `haproxy`: Load balancer (allyrion)
- `nfs_server`: NFS storage server (allyrion)
- `prometheus`: Metrics collection (allyrion)
- `grafana`: Observability dashboard (gardener)
- `loki`: Log aggregation (inchfield)
- `zfs`: ZFS storage nodes (allyrion, erenford, gardener)

## Key Variables

### Cluster Configuration
- `cluster_name`: "goldentooth"
- `kubernetes_version`: Current K8s version
- `network.infrastructure.cidr`: 10.4.0.0/20
- `network.service.cidr`: 172.16.0.0/20
- `network.pod.cidr`: 192.168.0.0/16

### Security
- Vault password file: `~/.goldentooth_vault_password`
- SSH configuration with public key authentication
- Automatic security updates enabled

### Node Architecture
- `host.architecture`: Automatically determined (arm64 for Pis, amd64 for x86)
- `host.fqdn`: Fully qualified domain names using cluster.domain
- `node.fqdn`: Node-specific FQDNs for cluster services

## Secrets Management

The `vault` file contains encrypted secrets including:
- SSH public keys
- API tokens and passwords
- AWS credentials for KMS seal
- Certificate authority passwords
- Service-specific authentication tokens

Use `goldentooth edit_vault` to modify encrypted values.

## Host Variables

Individual host variables in `host_vars/` override group variables and can specify:
- Node-specific network configurations
- Service-specific overrides
- Hardware-specific settings (especially for the GPU node)

## Best Practices

- Always use group variables for shared configuration
- Use host variables sparingly, only for node-specific overrides
- Keep sensitive data in the encrypted vault file
- Use the `clean_hostname` variable for consistent naming
- Leverage the `ipv4_address` variable for dynamic IP resolution