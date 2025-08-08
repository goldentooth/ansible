# Claude Code Installation for Goldentooth Cluster

This Ansible role installs and configures Claude Code CLI on all Goldentooth cluster nodes, providing AI-powered code assistance across the infrastructure.

## Features

- **NPX-based installation**: Uses `npx @anthropic-ai/claude-code-cli` for always-latest version
- **Convenient aliases**: Creates both `claude-code` and `cc` commands
- **Environment integration**: Configures shell environment with helpful aliases and functions
- **Cluster-wide deployment**: Installs on all nodes consistently

## Usage

Deploy Claude Code across the cluster:
```bash
goldentooth setup_claude_code
```

Or target specific nodes:
```bash
goldentooth setup_claude_code consul_server
```

## Post-Installation

After installation, users can access Claude Code on any cluster node:

```bash
# Long form
claude-code --help
claude-code chat

# Short alias  
cc --help
cc chat

# Helper function
claude_help
```

## Requirements

- Node.js and NPM (automatically installed if missing)
- Network access for NPX package downloads
- Valid ANTHROPIC_API_KEY environment variable (set by individual users)

## Files Created

- `/usr/local/bin/claude-code` - Main wrapper script
- `/usr/local/bin/cc` - Short alias wrapper  
- `/etc/profile.d/claude-code-env.sh` - Environment configuration

## Environment Configuration

The role creates shell aliases and a helper function:
- `claude-code` alias for full command
- `cc` alias for short access
- `claude_help()` function for usage information

Users should set their own ANTHROPIC_API_KEY:
```bash
export ANTHROPIC_API_KEY="your_key_here"
```

## Integration

This role integrates with the Goldentooth cluster infrastructure:
- Follows goldentooth naming conventions
- Uses cluster inventory groups
- Provides consistent experience across all nodes
- Supports both interactive and automated usage