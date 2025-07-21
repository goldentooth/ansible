# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.bootstrap_consul role.

## Overview

This role bootstraps the Consul ACL (Access Control List) system and generates the management token and gossip encryption key. It performs one-time bootstrap operations and displays the generated secrets for storage in the Ansible vault.

## Purpose

- Generate Consul gossip encryption key (one-time operation)
- Bootstrap Consul ACL system (one-time operation)
- Generate and extract the management token
- Handle bootstrap reset scenarios
- Display secrets for vault storage

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Gossip encryption key generation (one-time operation)
- ACL system bootstrap (one-time operation)
- Management token generation and extraction
- Bootstrap reset handling for multiple runs
- Clear display of secrets for manual vault storage

## Dependencies

- Requires Consul cluster to be running
- Must run before setup_consul_acl role
- Uses Consul server nodes for bootstrap

## Variables

- `consul.acl_bootstrap_reset_path`: Path for bootstrap reset file
- `consul.opt_path`: Consul data directory path  
- Generated variables:
  - `gossip_key`: The generated gossip encryption key
  - `consul_mgmt_token`: The generated management token

## Usage

Run this role first to bootstrap Consul:
```yaml
- { role: 'goldentooth.bootstrap_consul' }
```

After running, store the displayed secrets in vault:
```bash
goldentooth set_vault secret_vault.consul.gossip_key "GOSSIP_KEY_FROM_OUTPUT"
goldentooth set_vault secret_vault.consul.mgmt_token "TOKEN_FROM_OUTPUT"
```

Then run the setup role:
```yaml
- { role: 'goldentooth.setup_consul_acl' }
```

## Integration

- Provides management token for `goldentooth.setup_consul_acl` role
- Must run before any ACL policy or token creation
- Foundation for secure Consul service mesh operations

## Workflow

1. Run `goldentooth bootstrap_consul`
2. Copy the displayed gossip key and management token
3. Store secrets: 
   - `goldentooth set_vault secret_vault.consul.gossip_key "GOSSIP_KEY"`
   - `goldentooth set_vault secret_vault.consul.mgmt_token "TOKEN"`
4. Run `goldentooth setup_consul_acl` to create policies and tokens
5. Run `goldentooth setup_consul` to configure cluster with stored secrets