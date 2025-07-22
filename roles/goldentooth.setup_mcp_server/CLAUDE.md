# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_mcp_server role.

## Overview

This role deploys and manages the Goldentooth MCP (Model Context Protocol) server across cluster nodes. It downloads the latest release from GitHub, configures the systemd service, and ensures the service is running and automatically updated.

## Purpose

- Download latest MCP server release from GitHub
- Install MCP server binary to /usr/local/bin/
- Configure systemd service for the MCP server
- Manage service lifecycle (start/stop/restart)
- Support architecture-specific binaries (x86_64 and aarch64)

## Files

- `tasks/main.yaml`: Main task file for MCP server deployment
- `templates/goldentooth-mcp.service.j2`: Systemd service template
- `handlers/main.yaml`: Service restart handlers
- `defaults/main.yaml`: Default variables

## Key Features

### Automatic Release Detection
- Fetches latest release information from GitHub API
- Downloads appropriate binary for target architecture
- Supports both x86_64 and aarch64 (Raspberry Pi) architectures

### Service Management
- Configures systemd service with proper security settings
- Enables service to start on boot
- Includes restart policies and resource limits
- Proper logging configuration

### Architecture Support
- Automatically detects node architecture
- Downloads correct binary (goldentooth-mcp-x86_64-linux or goldentooth-mcp-aarch64-linux)
- Supports mixed Pi/x86 cluster deployments

### Security Features
- Runs service with minimal privileges
- Resource limits and security hardening
- Proper file permissions and ownership

## Dependencies

- Requires internet connectivity for GitHub API access
- Systemd for service management
- curl or wget for downloading releases

## Variables

Default variables (can be overridden in inventory):
- `mcp_server_user`: User to run the service (default: mcp)
- `mcp_server_group`: Group for the service (default: mcp)
- `mcp_server_install_dir`: Installation directory (default: /usr/local/bin)
- `mcp_server_log_level`: Log level (default: info)
- `mcp_server_github_repo`: GitHub repository (default: goldentooth/mcp-server)

## Usage

This role is typically called via the setup_mcp_server playbook:
```yaml
- { role: 'goldentooth.setup_mcp_server' }
```

Can also be run on specific hosts:
```bash
goldentooth setup_mcp_server
goldentooth setup_mcp_server --limit allyrion,bettley
```

## Integration

Works with:
- Systemd for service management
- GitHub Releases API for automatic updates
- Cluster-wide deployment across mixed architectures

## Security Considerations

- Service runs with dedicated user account
- Resource limits prevent resource exhaustion
- Secure systemd configuration with minimal privileges
- Automatic updates ensure latest security patches