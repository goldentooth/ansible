# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.set_bash_prompt role.

## Overview

This role configures custom bash prompts for cluster nodes with node identification and status information.

## Purpose

- Set custom bash prompts for cluster nodes
- Provide visual identification in shell sessions
- Include useful system information in prompt

## Files

- `tasks/main.yaml`: Main task file
- `files/bash_prompt.sh`: Common bash prompt script
- `templates/bash_prompt_local.sh.j2`: Node-specific prompt template

## Key Features

- Node-specific bash prompt customization
- Visual identification of current node
- Consistent prompt styling across cluster

## Dependencies

- Uses node-specific configuration
- Requires bash shell environment

## Variables

- `clean_hostname`: Used for prompt customization
- User-specific variables for prompt personalization

## Usage

Typically called as part of user configuration:
```yaml
- { role: 'goldentooth.set_bash_prompt' }
```