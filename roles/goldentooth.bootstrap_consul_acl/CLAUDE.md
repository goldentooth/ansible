# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.bootstrap_consul_acl role.

## Overview

This role bootstraps the Consul ACL (Access Control List) system for secure service mesh authentication and authorization.

## Purpose

- Bootstrap Consul ACL system
- Create initial ACL policies
- Configure node and service policies
- Set up secure Consul authentication

## Files

- `tasks/main.yaml`: Main task file
- `files/node-policy.hcl`: Node ACL policy
- `files/node-cli-policy.hcl`: Node CLI ACL policy

## Key Features

- ACL system initialization
- Node and service policy creation
- Secure authentication setup
- Integration with Consul cluster

## Dependencies

- Requires Consul cluster to be running
- Uses Consul management token
- Integrates with Consul server setup

## Variables

- `consul.mgmt_token`: Management token from vault
- ACL policy configurations
- Node and service policy settings

## Usage

Typically called via the bootstrap_consul_acl playbook:
```yaml
- { role: 'goldentooth.bootstrap_consul_acl' }
```

## Integration

Works with Consul setup and provides foundation for secure service mesh operations.