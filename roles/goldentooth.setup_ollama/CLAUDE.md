# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_ollama role.

## Overview

This role sets up Ollama, a local Large Language Model (LLM) inference server, on designated cluster nodes. Ollama provides an easy way to run local LLMs with a simple REST API interface.

## Purpose

- Install Ollama binary on x86_64 nodes (primarily velaryon GPU node)
- Configure Ollama as a systemd service for reliable operation  
- Set up API access for local LLM inference
- Enable model management and downloading
- Integrate with cluster networking and service discovery

## Files

- `tasks/main.yaml`: Main task file for installation and configuration
- `templates/ollama.service.j2`: Systemd service template
- `defaults/main.yaml`: Default variables and configuration
- `handlers/main.yaml`: Service restart handlers

## Key Features

- Direct binary installation from official Ollama releases
- Systemd service management with auto-restart
- Configurable API binding (host/port)
- Model storage in shared directories
- Integration with cluster networking
- GPU acceleration support on compatible hardware

## Dependencies

- x86_64 architecture (Ollama doesn't support ARM64 officially)
- Sufficient disk space for model storage
- Network connectivity for model downloads
- Optional: NVIDIA GPU for acceleration

## Architecture

- **Primary Use**: velaryon (x86_64 GPU node) for local LLM inference
- **API Access**: REST API compatible with OpenAI format
- **Model Storage**: Configurable model directory for persistent storage
- **Service Management**: Systemd for reliable operation

## Variables

Key configuration variables (defined in defaults/main.yaml):
- `ollama.version`: Ollama version to install
- `ollama.api_host`: API binding host (default: 0.0.0.0)
- `ollama.api_port`: API binding port (default: 11434)
- `ollama.models_dir`: Directory for model storage
- `ollama.user`: System user for Ollama service
- `ollama.group`: System group for Ollama service

## Usage

Typically called via the setup_ollama playbook:
```yaml
- { role: 'goldentooth.setup_ollama' }
```

## Model Management

- Models are downloaded on-demand via API calls
- Popular models: llama3.2, codellama, mistral, phi3
- Model storage is persistent across service restarts
- Models can be managed via `ollama` CLI or API

## Integration

- REST API endpoint: `http://velaryon:11434`
- Compatible with OpenAI-style chat completions
- Can be integrated with external tools and applications
- Supports streaming responses for real-time inference

## Security Considerations

- Service runs as dedicated user account
- API binding configurable for network access control
- Model files protected with appropriate permissions
- Integration with cluster firewall rules

## Performance Optimization

- GPU acceleration automatically detected on compatible hardware
- Configurable memory usage and concurrent requests
- Model caching for improved response times
- Support for quantized models for memory efficiency