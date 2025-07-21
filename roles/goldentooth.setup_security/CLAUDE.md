# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_security role.

## Overview

This role configures security settings for cluster nodes including SSH hardening, firewall, and system security.

## Purpose

- Configure SSH security settings
- Set up firewall rules
- Configure system security hardening
- Implement security best practices

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- SSH security configuration
- Firewall setup and rules
- System security hardening
- Security monitoring setup
- APT package blocking (prevents Docker installation that conflicts with Kubernetes)

## Dependencies

- Works with geerlingguy.security role
- Requires appropriate system permissions
- Integrates with cluster security policies

## Variables

- Security configuration from inventory
- SSH and firewall settings
- System hardening parameters

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.setup_security' }
```