# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the roles directory.

## Overview

This directory contains both custom goldentooth roles and vendored community roles that provide the building blocks for cluster configuration.

## Role Categories

### Vendored Community Roles
These are external roles managed via `requirements.yml`:
- `geerlingguy.containerd`: Container runtime setup
- `geerlingguy.docker`: Docker container platform setup
- `geerlingguy.nfs`: NFS server configuration
- `geerlingguy.security`: Security hardening (SSH, fail2ban, auto-updates)

### Custom Goldentooth Roles
All custom roles follow the `goldentooth.*` naming convention:

#### Infrastructure Management
- `goldentooth.set_hostname`: Set system hostname
- `goldentooth.set_motd`: Set message of the day with node-specific ASCII art
- `goldentooth.set_bash_prompt`: Configure custom bash prompts
- `goldentooth.setup_user`: User account configuration
- `goldentooth.setup_etc_hosts`: Configure /etc/hosts file
- `goldentooth.setup_security`: Security configuration
- `goldentooth.setup_networking`: Network configuration
- `goldentooth.setup_docker`: Docker setup wrapper

#### Certificate Management
- `goldentooth.init_cluster_ca`: Initialize root and intermediate CAs
- `goldentooth.bootstrap_cluster_ca`: Bootstrap CA client configuration (one-time)
- `goldentooth.setup_cluster_ca`: Setup CA components and certificate renewal
- `goldentooth.rotate_consul_certs`: Rotate Consul certificates
- `goldentooth.rotate_nomad_certs`: Rotate Nomad certificates
- `goldentooth.rotate_vault_certs`: Rotate Vault certificates
- `goldentooth.rotate_grafana_certs`: Rotate Grafana certificates
- `goldentooth.rotate_loki_certs`: Rotate Loki certificates
- `goldentooth.rotate_vector_certs`: Rotate Vector certificates

#### HashiCorp Stack
- `goldentooth.setup_consul`: Consul service mesh setup
- `goldentooth.setup_nomad`: Nomad orchestration setup
- `goldentooth.setup_vault`: Vault secrets management setup
- `goldentooth.bootstrap_consul_acl`: Bootstrap Consul ACL system

#### Kubernetes
- `goldentooth.bootstrap_k8s`: Bootstrap Kubernetes cluster
- `goldentooth.reset_k8s`: Reset Kubernetes cluster
- `goldentooth.install_helm`: Install Helm package manager
- `goldentooth.install_argo_cd`: Install Argo CD
- `goldentooth.install_argo_cd_apps`: Install Argo CD applications

#### Observability
- `goldentooth.setup_prometheus`: Prometheus metrics setup
- `goldentooth.setup_grafana`: Grafana dashboard setup
- `goldentooth.setup_loki`: Loki log aggregation setup
- `goldentooth.setup_vector`: Vector log shipping setup
- `goldentooth.setup_node_homepages`: Node status pages

#### Storage & Networking
- `goldentooth.setup_nfs_mounts`: NFS mount configuration
- `goldentooth.setup_zfs`: ZFS storage setup
- `goldentooth.setup_haproxy`: HAProxy load balancer setup
- `goldentooth.setup_envoy`: Envoy proxy setup

#### Compute Workloads
- `goldentooth.setup_slurm`: Slurm job scheduler setup
- `goldentooth.setup_ray`: Ray distributed computing setup
- `goldentooth.setup_conda`: Conda environment management

#### Hardware-Specific
- `goldentooth.pi_config`: Raspberry Pi configuration

#### Certificate Authority Tools
- `goldentooth.install_step_ca`: Install Step-CA
- `goldentooth.upgrade_k8s`: Kubernetes upgrade procedures

## Role Structure

### Standard Goldentooth Role Layout
```
goldentooth.role_name/
├── tasks/
│   └── main.yaml          # Main task file
├── templates/             # Jinja2 templates (if needed)
├── files/                 # Static files (if needed)
├── defaults/              # Default variables (if needed)
└── handlers/              # Handlers (if needed)
```

### Common Patterns

#### Certificate Renewal
Many roles include certificate renewal configurations:
- `cert-renewer@<service>.conf.j2` templates
- Systemd service and timer files
- Integration with Step-CA

#### Service Configuration
Service setup roles typically include:
- Service configuration templates
- Environment variable files
- Systemd service definitions
- Policy files for HashiCorp services

#### Multi-file Tasks
Some roles split tasks across multiple files:
- `main.yaml`: Primary task orchestration
- `update_config.yaml`: Configuration updates

## Individual Role Documentation

Each goldentooth role includes its own detailed CLAUDE.md file with specific guidance:

- **Purpose and overview**: What the role does and why it's needed
- **File structure**: Templates, tasks, and configuration files
- **Key features**: Major capabilities and functionality
- **Dependencies**: Required services and prerequisites
- **Variables**: Role-specific configuration options
- **Usage examples**: How to invoke the role
- **Integration points**: How it works with other roles
- **Security considerations**: Important security aspects

To access role-specific documentation, see `roles/goldentooth.*/CLAUDE.md` files.

## Key Variables

Roles leverage variables from:
- `inventory/group_vars/all/vars.yaml`: Global configuration
- `inventory/group_vars/all/vault`: Encrypted secrets
- Role-specific defaults (when present)

## Best Practices

### Role Development
- Follow the `goldentooth.*` naming convention
- Use descriptive task names
- Include appropriate tags for selective execution
- Use templates for configuration files
- Include handlers for service management

### File Organization
- Keep tasks in `tasks/main.yaml` unless multiple files needed
- Use `templates/` for Jinja2 configuration templates
- Use `files/` for static files that don't require templating
- Use `defaults/` sparingly, prefer inventory variables

### Security Considerations
- Never hardcode secrets in roles
- Use vault variables for sensitive data
- Ensure proper file permissions on sensitive files
- Use TLS for all inter-service communication

## Dependencies

- Roles may depend on Step-CA for certificate management
- HashiCorp roles have dependencies on Consul for service discovery
- Some roles require specific host groups to be configured first