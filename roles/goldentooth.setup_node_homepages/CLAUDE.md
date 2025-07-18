# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_node_homepages role.

## Overview

This role sets up individual status pages for each cluster node, providing visual identification and status information.

## Purpose

- Create node-specific status pages
- Provide visual identification for cluster nodes
- Display node status and information
- Set up web-based node monitoring

## Files

- `tasks/main.yaml`: Main task file
- `templates/index.html.j2`: Node homepage template
- `templates/node-homepage.conf.j2`: Nginx configuration template
- `templates/node-homepages-proxy.conf.j2`: Proxy configuration template
- `files/[hostname].png`: Node-specific images

## Key Features

- Node-specific status pages with custom images
- Nginx configuration for web serving
- Proxy configuration for load balancer integration
- Visual identification of cluster nodes

## Dependencies

- Requires Nginx web server
- Uses node-specific images and configuration
- Integrates with load balancer setup

## Variables

- `node_homepage.web_root`: Web root directory
- `node_homepage.nginx.*`: Nginx configuration
- Node-specific variables

## Usage

Typically called via the setup_node_homepages playbook:
```yaml
- { role: 'goldentooth.setup_node_homepages' }
```

## Integration

Works with HAProxy and load balancer for web-based node identification.