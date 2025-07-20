# goldentooth.sync_kubeconfig

This role synchronizes the Kubernetes configuration file to both normal and root users on cluster nodes and the local machine.

## Purpose

Ensures that kubeconfig is available to:
- Regular users for development and administration
- Root users for system-level operations
- Local machine for cluster management

## Variables

- `kubeconfig_source_path`: Path to the source kubeconfig file (default: `/etc/kubernetes/admin.conf`)
- `regular_user`: The regular user to sync kubeconfig to (default: `{{ ansible_user }}`)
- `sync_to_local`: Whether to sync to local machine (default: `true`)

## Tasks

1. Ensures kubeconfig directory exists for both users
2. Copies kubeconfig file with appropriate permissions
3. Sets proper ownership for each user
4. Optionally syncs to local machine

## Usage

This role is typically run after Kubernetes cluster initialization or when kubeconfig needs to be updated across the cluster.