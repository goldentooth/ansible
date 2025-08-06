# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.set_motd role.

## Overview

This role sets custom Message of the Day (MOTD) with node-specific ASCII art for each cluster node using a simple, elegant SSH-based approach.

## Purpose

- Set custom MOTD for each cluster node with beautiful ASCII art
- Display node-specific ASCII art on normal SSH login
- Provide visual identification for different nodes
- Maintain clean output for goldentooth CLI operations

## Files

- `tasks/main.yaml`: Main task file for MOTD configuration
- `files/[hostname].txt`: ASCII art files for each node (17 total)
- `handlers/main.yaml`: SSH service restart handler

## Key Features

- **Node-specific ASCII art**: Each node displays unique, beautiful ASCII art
- **Clean CLI operations**: Goldentooth CLI commands have no MOTD pollution
- **Simple architecture**: Uses SSH's built-in `PrintMotd` behavior
- **No complex logic**: Elegant solution using SSH client options
- **Automatic cleanup**: Removes old PAM configurations that caused duplication

## How It Works

The solution leverages SSH's built-in MOTD handling:

1. **Static MOTD**: Node-specific ASCII art stored directly in `/etc/motd`
2. **SSH Configuration**: `PrintMotd yes` in SSH daemon config
3. **CLI Clean Output**: Goldentooth CLI uses `-T` flag to suppress MOTD
4. **Interactive Sessions**: Direct SSH shows beautiful ASCII art
5. **PAM Cleanup**: Removes duplicate PAM MOTD entries

### SSH Behavior
- **Normal SSH**: `ssh root@node` shows MOTD (beautiful ASCII art)
- **Goldentooth CLI**: `ssh -T root@node` suppresses MOTD (clean output)
- **Interactive shells**: `ssh -t root@node bash --noprofile` (clean with terminal)

## Dependencies

- SSH daemon configuration permissions
- Node-specific ASCII art files for all cluster nodes
- PAM system access for cleanup

## Variables

- `clean_hostname`: Used to select appropriate ASCII art file from `files/` directory
- `inventory_hostname`: Used in role context

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.set_motd' }
```

Or via goldentooth CLI:
```bash
goldentooth set_motd all
```

## Integration with Goldentooth CLI

The goldentooth CLI uses SSH client options for clean operations:
- **Command execution**: Uses `-T` flag (no pseudo-terminal, suppresses MOTD)
- **Interactive shells**: Uses `bash --noprofile` to skip profile scripts
- **File operations**: Standard SSH without MOTD pollution

## Technical Implementation

### SSH Options Used by Goldentooth CLI
```bash
# Clean command execution (no MOTD)
ssh -T -o StrictHostKeyChecking=no -o LogLevel=ERROR -q root@host "command"

# Clean interactive shell (no MOTD, keeps terminal)
ssh -t -o StrictHostKeyChecking=no -o LogLevel=ERROR -q root@host "bash --noprofile"
```

### Role Tasks
1. **Set MOTD**: Copy node-specific ASCII art to `/etc/motd`
2. **Clean PAM**: Remove duplicate PAM MOTD entries that cause doubling
3. **Configure SSH**: Enable `PrintMotd yes` in SSH daemon config
4. **Restart SSH**: Ensure configuration takes effect

This approach provides the perfect balance of beautiful visual identification for manual SSH access while maintaining completely clean output for automated goldentooth CLI operations.