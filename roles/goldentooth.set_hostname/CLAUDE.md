# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.set_hostname role.

## Overview

This role sets the system hostname for cluster nodes using the inventory hostname configuration.

## Purpose

- Set system hostname from inventory
- Configure hostname in system files
- Ensure consistent hostname across cluster nodes

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Uses `clean_hostname` variable for consistent naming
- Updates system hostname configuration
- Ensures hostname persistence across reboots

## Dependencies

- Uses inventory hostname configuration
- Requires appropriate system permissions

## Variables

- `clean_hostname`: Cleaned version of inventory hostname
- `inventory_hostname`: Ansible inventory hostname

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.set_hostname' }
```