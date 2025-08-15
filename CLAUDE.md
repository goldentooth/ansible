# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Ansible-based infrastructure management system for the "goldentooth" Pi cluster. It manages configuration for a hybrid cluster consisting of Raspberry Pi nodes and x86 systems running Kubernetes, HashiCorp Consul/Nomad/Vault, and various observability tools.

The repository is typically accessed through the `goldentooth` CLI tool (a Bash script from the `goldentooth/bash` repository) which provides a unified interface for all cluster operations. The CLI is installed locally and available in the PATH.

## Key Architecture

### Cluster Structure
- **Pi Nodes**: 12 Raspberry Pi systems (allyrion, bettley, cargyll, dalt, erenford, fenn, gardener, harlton, inchfield, jast, karstark, lipps)
- **x86 Node**: 1 GPU-enabled system (velaryon)
- **Services**: Kubernetes, Consul service mesh, Nomad workload orchestration, Vault secrets management

### Core Components
- **Kubernetes**: Multi-control plane setup (bettley, cargyll, dalt) with mixed Pi/x86 workers
- **HashiCorp Stack**: Consul servers on control plane nodes, Nomad for workload scheduling, Vault for secrets
- **Observability**: Prometheus, Grafana, Loki logging, Vector log shipping
- **PKI**: Step-CA for certificate management with automated renewal
- **Storage**: NFS exports, ZFS on select nodes

## Common Commands

**IMPORTANT**: Use the `goldentooth` CLI tool instead of running Ansible directly. The CLI is a Bash script that provides a unified interface for all cluster operations.

### Basic Operations
```bash
# Check if all hosts are reachable
goldentooth ping all

# Get uptime for all hosts
goldentooth uptime all

# Execute SSH commands on specific hosts
goldentooth exec node1,node2 "free -h"

# Debug variables on hosts
goldentooth debug_var node1 "ansible_hostname"
```

### Cluster Management
```bash
# Install Ansible dependencies
goldentooth install

# Lint Ansible roles
goldentooth lint

# Configure all hosts in the cluster
goldentooth configure_cluster

# Bootstrap Kubernetes cluster
goldentooth bootstrap_k8s

# Reset Kubernetes cluster
goldentooth reset_k8s
```

### Service Setup
```bash
# Setup individual services
goldentooth setup_consul
goldentooth setup_nomad
goldentooth setup_vault
goldentooth setup_grafana
goldentooth setup_loki
goldentooth setup_prometheus
goldentooth setup_docker
goldentooth setup_envoy
goldentooth setup_mcp_server
```

### Certificate Management
```bash
# Bootstrap cluster CA (one-time initial setup)
goldentooth bootstrap_cluster_ca

# Setup cluster CA components and certificate renewal
goldentooth setup_cluster_ca

# Initialize Root and Intermediate CAs
goldentooth init_cluster_ca

# Certificate management
goldentooth setup_consul          # Includes certificate generation and renewal
goldentooth setup_nomad           # Includes certificate generation and renewal
goldentooth setup_vault           # Includes certificate generation and renewal
goldentooth setup_grafana         # Includes certificate generation and renewal
goldentooth rotate_loki_certs
goldentooth rotate_vector_certs
```

### Administrative Tasks
```bash
# Edit encrypted vault
goldentooth edit_vault

# Start interactive Ansible console
goldentooth console all

# Cleanly shut down cluster
goldentooth shutdown
```

### Direct Ansible Commands (Alternative)
If you need to run Ansible directly, use these patterns:
```bash
# Run a playbook against all hosts
ansible-playbook -i inventory/hosts playbooks/configure_cluster.yaml

# Run against specific host group
ansible-playbook -i inventory/hosts playbooks/setup_consul.yaml --limit consul_server

# Run with vault password
ansible-playbook -i inventory/hosts playbooks/setup_vault.yaml --ask-vault-pass
```

## Important Configuration

### Vault Integration
- Vault password file: `~/.goldentooth_vault_password`
- Secrets stored in `inventory/group_vars/all/vault`
- AWS KMS seal configured for Vault

### Networking
- Infrastructure CIDR: 10.4.0.0/20
- Service CIDR: 172.16.0.0/20
- Pod CIDR: 192.168.0.0/16
- MetalLB range: 10.4.11.0/24

### Certificate Management
- Step-CA server on `jast` node
- Automated certificate renewal via systemd timers
- Cluster-wide CA certificate at `/etc/ssl/certs/goldentooth.pem`

## Key Directories

- `playbooks/`: Ansible playbooks for specific operations
- `roles/goldentooth.*`: Custom roles for cluster-specific configurations
- `roles/geerlingguy.*`: Vendored community roles
- `inventory/`: Host definitions and group variables
- `inventory/group_vars/all/vars.yaml`: Main configuration variables

## Additional Documentation

This repository includes detailed CLAUDE.md documentation throughout its structure:

- **`inventory/CLAUDE.md`**: Host groups, variables, and secrets management
- **`playbooks/CLAUDE.md`**: Playbook categories and usage patterns
- **`roles/CLAUDE.md`**: Role organization and conventions
- **`roles/goldentooth.*/CLAUDE.md`**: Individual documentation for each of the 41 goldentooth roles

Each role's CLAUDE.md file provides specific guidance on purpose, dependencies, configuration, and integration with other cluster components.

## Development Notes

- All custom roles follow the `goldentooth.*` naming convention
- Role templates use Jinja2 with extensive variable substitution
- Certificate renewal handled via `cert-renewer@.service` systemd templates
- ZFS configuration includes automated snapshots via Sanoid

## Goldentooth CLI Tool

The `goldentooth` command provides a unified interface for all cluster operations:

- **Source**: Located in `../bash/goldentooth.sh` and available as `goldentooth` in PATH
- **Environment**: Uses `GOLDENTOOTH_ANSIBLE_PATH` (defaults to `~/Projects/goldentooth/ansible`)
- **Functions**: Each subcommand maps to a Bash function that wraps Ansible operations
- **Available Commands**: Run `goldentooth usage` to see all available subcommands
- **Common Pattern**: Most commands follow the pattern of changing to the Ansible directory and running the appropriate playbook

## Security Considerations

- SSH access limited to root and designated user account
- Fail2ban enabled on all nodes
- Automatic security updates configured with scheduled reboots
- TLS encryption for all inter-service communication
- Consul ACL system with per-service policies