# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_gh_cli role.

## Overview

This role installs and configures GitHub CLI (gh) on all cluster nodes, providing command-line GitHub integration across the Goldentooth infrastructure.

## Purpose

- Install GitHub CLI from official GitHub releases
- Create convenient shell aliases for GitHub CLI
- Configure environment for optimal GitHub CLI usage
- Provide unified GitHub integration across the cluster

## Files

- `tasks/main.yaml`: Main installation and configuration tasks
- `templates/gh-cli-env.sh.j2`: GitHub CLI environment configuration
- `handlers/main.yaml`: Service restart handlers

## Key Features

- **Official binary installation**: Downloads and installs official GitHub CLI releases
- **ARM64/AMD64 support**: Automatically detects and installs correct architecture
- **Shell integration**: Creates `gh` command and helpful aliases
- **Environment configuration**: Sets up optimal GitHub CLI environment
- **Cluster-wide availability**: Installs on all nodes for consistent access
- **Auto-updates**: Easy to redeploy for updates

## Dependencies

- `curl` or `wget` for downloading GitHub CLI releases
- `tar` for extracting archives
- Network connectivity for GitHub releases API

## Variables

Uses cluster-wide variables from inventory:
- `gh_cli_version`: GitHub CLI version to install (default: latest)
- `gh_cli_install_path`: Installation directory (default: /usr/local/bin)

## Usage

Typically called as part of development environment setup:
```yaml
- { role: 'goldentooth.setup_gh_cli' }
```

Or via goldentooth CLI:
```bash
goldentooth setup_gh_cli
```

## Integration Points

- **Cross-platform**: Works on both ARM64 (Pi) and AMD64 (x86) nodes
- **Shell environment**: Integrates with bash profile setup
- **Cluster-wide**: Available on all nodes for development work
- **Git integration**: Works seamlessly with existing Git setups

## Security Considerations

- Downloads official releases from GitHub
- Verifies binary integrity
- Installs to system-wide location with proper permissions
- No API keys stored by default (users configure individually)

## Post-Installation Usage

After installation, users can access GitHub CLI via:
```bash
# Main command
gh --help
gh auth login
gh repo clone user/repo

# Check status
gh status
gh auth status

# Common operations  
gh pr list
gh issue list
gh repo create
```

## Authentication

Users will need to authenticate individually:
```bash
# Web-based authentication
gh auth login

# Token-based authentication
gh auth login --with-token < token.txt
```