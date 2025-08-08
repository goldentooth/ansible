# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_claude_code role.

## Overview

This role installs and configures Claude Code CLI on all cluster nodes, providing AI-powered code assistance across the Goldentooth infrastructure.

## Purpose

- Install Claude Code CLI via NPX on all cluster nodes
- Create convenient shell aliases for Claude Code
- Configure environment for optimal Claude Code usage
- Provide unified AI coding assistance across the cluster

## Files

- `tasks/main.yaml`: Main installation and configuration tasks
- `templates/claude-code-env.sh.j2`: Claude Code environment configuration

## Key Features

- **NPX-based installation**: Uses `npx @anthropic-ai/claude-code` for latest version
- **Shell integration**: Creates `claude-code` and `cc` aliases
- **Environment configuration**: Sets up optimal Claude Code environment
- **Node.js dependency**: Ensures Node.js is available for NPX
- **Cluster-wide availability**: Installs on all nodes for consistent access

## Dependencies

- Node.js (installed via `setup_nodejs` playbook)
- NPM/NPX (bundled with Node.js)
- Network connectivity for package download

## Variables

Uses cluster-wide variables from inventory:
- `claude_code_enabled`: Whether to enable Claude Code (default: true)
- `claude_code_aliases`: List of shell aliases to create (default: ['claude-code', 'cc'])

## Usage

Typically called as part of development environment setup:
```yaml
- { role: 'goldentooth.setup_claude_code' }
```

Or via goldentooth CLI:
```bash
goldentooth setup_claude_code
```

## Integration Points

- **Requires Node.js**: Should be run after Node.js installation
- **Shell environment**: Integrates with bash profile setup
- **Cluster-wide**: Available on all nodes for development work

## Security Considerations

- Uses NPX for secure package execution
- No persistent installation of Claude Code binary
- Environment variables handled securely

## Post-Installation Usage

After installation, users can access Claude Code via:
```bash
# Direct command
claude-code

# Short alias
cc

# Or via npx directly
npx @anthropic-ai/claude-code
```