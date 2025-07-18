# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.install_argo_cd role.

## Overview

This role installs Argo CD on the Kubernetes cluster for GitOps-based application deployment and management.

## Purpose

- Install Argo CD on Kubernetes cluster
- Configure GitOps workflows
- Set up application deployment automation
- Configure Argo CD for cluster management

## Files

- `tasks/main.yaml`: Main task file

## Key Features

- Argo CD installation via Helm
- GitOps configuration
- Application deployment automation
- Cluster integration

## Dependencies

- Requires Kubernetes cluster to be running
- Requires Helm to be installed
- Uses cluster configuration from inventory

## Variables

- `argo_cd.*`: Argo CD configuration variables
- Kubernetes cluster settings
- GitOps repository configuration

## Usage

Typically called after Helm installation:
```yaml
- { role: 'goldentooth.install_argo_cd' }
```