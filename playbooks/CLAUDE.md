# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the playbooks directory.

## Overview

This directory contains Ansible playbooks that define the high-level orchestration for cluster operations. Each playbook typically combines multiple roles to achieve a specific goal.

## Playbook Categories

### Cluster Management
- `configure_cluster.yaml`: Configure all hosts with base settings (hostname, MOTD, security, user setup)
- `cleanup.yaml`: Perform various cleanup tasks across the cluster
- `shutdown.yaml`: Cleanly shut down all hosts in the cluster
- `pi_config.yaml`: Configure Raspberry Pi-specific settings

### Certificate Authority
- `init_cluster_ca.yaml`: Initialize Root and Intermediate Certificate Authorities
- `bootstrap_cluster_ca.yaml`: Bootstrap cluster CA client configuration (one-time setup)
- `setup_cluster_ca.yaml`: Setup cluster CA components and certificate renewal system
- `zap_cluster_ca.yaml`: Delete the old cluster Certificate Authority

### Kubernetes Operations
- `bootstrap_k8s.yaml`: Bootstrap Kubernetes cluster with kubeadm
- `reset_k8s.yaml`: Reset Kubernetes cluster (destructive operation)
- `install_k8s_packages.yaml`: Install Kubernetes packages on nodes
- `uninstall_k8s_packages.yaml`: Remove Kubernetes packages
- `upgrade_k8s.yaml`: Upgrade Kubernetes to newer version
- `install_helm.yaml`: Install Helm package manager
- `install_argo_cd.yaml`: Install Argo CD for GitOps
- `install_argo_cd_apps.yaml`: Install Argo CD applications

### HashiCorp Stack
- `setup_consul.yaml`: Setup Consul service mesh
- `setup_nomad.yaml`: Setup Nomad workload orchestration
- `setup_vault.yaml`: Setup HashiCorp Vault secrets management
- `bootstrap_consul.yaml`: Bootstrap Consul (generate gossip key and ACL management token)
- `setup_consul_acl.yaml`: Setup Consul ACL policies and tokens

### Certificate Rotation
- `rotate_consul_certs.yaml`: Rotate Consul TLS certificates
- `rotate_nomad_certs.yaml`: Rotate Nomad TLS certificates
- `rotate_vault_certs.yaml`: Rotate Vault TLS certificates
- `rotate_grafana_certs.yaml`: Rotate Grafana TLS certificates
- `rotate_loki_certs.yaml`: Rotate Loki TLS certificates
- `rotate_vector_certs.yaml`: Rotate Vector TLS certificates

### Infrastructure Services
- `setup_docker.yaml`: Setup Docker container runtime
- `setup_envoy.yaml`: Setup Envoy proxy
- `setup_load_balancer.yaml`: Setup HAProxy load balancer
- `setup_networking.yaml`: Configure network settings
- `setup_nfs_exports.yaml`: Setup NFS exports
- `setup_nfs_mounts.yaml`: Setup NFS mounts
- `setup_ntp.yaml`: Setup NTP time synchronization
- `setup_apt_repos.yaml`: Setup package repositories
- `setup_zfs.yaml`: Setup ZFS storage

### Observability
- `setup_prometheus.yaml`: Setup Prometheus metrics collection
- `setup_grafana.yaml`: Setup Grafana dashboards
- `setup_loki.yaml`: Setup Loki log aggregation
- `setup_vector.yaml`: Setup Vector log shipping
- `setup_node_homepages.yaml`: Setup node status pages

### Compute Workloads
- `setup_slurm.yaml`: Setup Slurm job scheduler
- `setup_ray.yaml`: Setup Ray distributed computing

### Certificate Authority Tools
- `install_step_ca.yaml`: Install Step-CA certificate authority
- `install_step_cli.yaml`: Install Step CLI tools

### Utility Playbooks
- `adhoc.yaml`: Run ad-hoc Ansible tasks
- `msg.yaml`: Evaluate messages on hosts (debugging)
- `var.yaml`: Evaluate variables on hosts (debugging)

## Playbook Patterns

### Common Structure
Most playbooks follow this pattern:
```yaml
# Description comment
- name: 'Descriptive task name'
  hosts: 'target_group'
  remote_user: 'root'  # or specific user
  roles:
    - { role: 'goldentooth.role_name' }
  handlers:
    - name: 'Handler name'
      # Handler tasks
```

### Multi-Play Playbooks
Some playbooks have multiple plays for different user contexts:
- Root user configuration
- Regular user configuration
- Service-specific configurations

### Error Handling
Playbooks include appropriate handlers for:
- Service restarts
- System reboots
- Configuration reloads

## Usage via CLI

All playbooks should be run via the `goldentooth` CLI tool:
```bash
goldentooth <command_name>
```

For direct Ansible execution (not recommended):
```bash
ansible-playbook -i inventory/hosts playbooks/<playbook_name>.yaml
```

## Dependencies

- Playbooks rely on roles in the `roles/` directory
- Many playbooks require vault secrets to be accessible
- Some playbooks have ordering dependencies (e.g., CA must be setup before services)

## Best Practices

- Use descriptive names for plays and tasks
- Include helpful comments explaining complex operations
- Use appropriate host targeting
- Include necessary handlers for service management
- Test playbooks in development before production use

## Related Documentation

For more information about playbook components:
- See `../inventory/CLAUDE.md` for host groups and variables used by playbooks
- See `../roles/CLAUDE.md` for role organization and conventions
- See `../roles/goldentooth.*/CLAUDE.md` for detailed documentation on each role used in playbooks