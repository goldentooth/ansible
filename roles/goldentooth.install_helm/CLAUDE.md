# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.install_helm role.

## Overview

This role installs Helm package manager on the Kubernetes cluster for application deployment and management.

## Purpose

- Install Helm package manager
- Configure Helm for cluster use
- Set up Helm repositories
- Prepare for application deployments

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Helm binary installation
- Cluster integration setup
- Repository configuration
- RBAC configuration for Helm

## Dependencies

- Requires Kubernetes cluster to be running
- Uses kubectl for cluster access
- Requires appropriate permissions

## Variables

- Kubernetes configuration variables
- Helm version and installation settings

## Usage

Typically called after Kubernetes bootstrap:
```yaml
- { role: 'goldentooth.install_helm' }
```