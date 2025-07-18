# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_etc_hosts role.

## Overview

This role configures the /etc/hosts file for cluster nodes to ensure proper hostname resolution within the cluster.

## Purpose

- Configure /etc/hosts for cluster hostname resolution
- Set up proper IP to hostname mappings
- Ensure consistent hostname resolution across nodes

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Cluster-wide hostname resolution
- IP address to hostname mapping
- Consistent DNS resolution
- Support for cluster domain configuration

## Dependencies

- Uses inventory hostname and IP configuration
- Requires appropriate system permissions
- Integrates with cluster networking

## Variables

- `cluster.domain`: Cluster domain configuration
- Host IP addresses and hostnames from inventory
- Network configuration variables

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.setup_etc_hosts' }
```