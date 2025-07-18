# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.install_argo_cd_apps role.

## Overview

This role installs Argo CD applications and application sets for GitOps-based deployment management.

## Purpose

- Install Argo CD applications
- Configure application sets
- Set up GitOps deployment workflows
- Configure application projects

## Files

- `tasks/main.yaml`: Main task file
- `tasks/app_projects/gitops_repo.yaml`: Application project configuration
- `tasks/application_sets/gitops_repo.yaml`: Application set configuration

## Key Features

- Argo CD application installation
- Application set configuration
- GitOps workflow setup
- Application project management

## Dependencies

- Requires Argo CD to be installed
- Uses GitOps repository configuration
- Integrates with Kubernetes cluster

## Variables

- Argo CD application configuration
- GitOps repository settings
- Application deployment parameters

## Usage

Typically called via the install_argo_cd_apps playbook:
```yaml
- { role: 'goldentooth.install_argo_cd_apps' }
```

## Integration

Works with Argo CD and GitOps workflows for application deployment.