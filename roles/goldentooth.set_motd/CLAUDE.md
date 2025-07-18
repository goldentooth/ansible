# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.set_motd role.

## Overview

This role sets custom Message of the Day (MOTD) with node-specific ASCII art for each cluster node.

## Purpose

- Set custom MOTD for each cluster node
- Display node-specific ASCII art on login
- Provide visual identification for different nodes

## Files

- `tasks/main.yaml`: Main task file
- `files/[hostname].txt`: ASCII art files for each node

## Key Features

- Node-specific ASCII art for visual identification
- Custom MOTD display on SSH login
- Helps identify which node you're connected to

## Dependencies

- Uses node-specific ASCII art files
- Requires appropriate system permissions

## Variables

- `clean_hostname`: Used to select appropriate ASCII art file

## Usage

Typically called as part of cluster configuration:
```yaml
- { role: 'goldentooth.set_motd' }
```