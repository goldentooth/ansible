# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_distributed_llama role.

## Overview

This role sets up distributed-llama, a distributed computing framework for Large Language Model (LLM) inference across the Goldentooth cluster. It enables running LLM inference workloads distributed across multiple Raspberry Pi nodes.

## Purpose

- Install and compile distributed-llama binaries on cluster nodes
- Configure worker and root node setups for distributed LLM inference
- Set up systemd services for automated distributed-llama management
- Enable distributed tensor parallelism across ARM and x86 nodes
- Integrate with cluster networking for high-speed synchronization

## Files

- `tasks/main.yaml`: Main task file for installation and configuration
- `templates/dllama-worker.service.j2`: Systemd service template for worker nodes
- `templates/dllama-root.service.j2`: Systemd service template for root node
- `templates/dllama-api.service.j2`: Systemd service template for API server
- `templates/start-dllama.sh.j2`: Startup script template
- `defaults/main.yaml`: Default variables and configuration

## Key Features

- Multi-architecture support (ARM64 Pi nodes + x86_64 GPU node)
- Distributed tensor parallelism for LLM inference
- Automatic worker node discovery via Consul service registry
- Systemd service management for reliable operation
- Integration with cluster networking (10.4.0.0/20 CIDR)
- Support for both q40 and f32 model quantization

## Dependencies

- Requires C++ compiler and build tools
- Python 3 for build process
- Git for source code management
- Network connectivity between all cluster nodes
- Consul service registry for node discovery (optional but recommended)

## Architecture

- **Worker Nodes**: Process neural network slices, lightweight operation
- **Root Node**: Loads model, manages synchronization, coordinates inference
- **API Server**: Optional HTTP API interface for inference requests

## Variables

Key configuration variables (defined in defaults/main.yaml):
- `distributed_llama.version`: Git branch/tag to build
- `distributed_llama.build_dir`: Build directory location
- `distributed_llama.worker_port`: Port for worker node communication
- `distributed_llama.threads`: Number of CPU threads per node
- `distributed_llama.models_dir`: Directory for model storage
- `distributed_llama.buffer_float_type`: Synchronization precision (q80/f32)

## Usage

Typically called via the setup_distributed_llama playbook:
```yaml
- { role: 'goldentooth.setup_distributed_llama' }
```

## Node Configuration

### Worker Nodes
- Runs on all Pi nodes (12 ARM64 systems)
- Lightweight operation, processes neural network slices
- Automatically registers with root node via network discovery

### Root Node
- Designated primary node (typically a control plane node like bettley)
- Loads model weights and tokenizer
- Coordinates inference across all worker nodes
- Manages synchronization and result aggregation

### GPU Node (velaryon)
- x86_64 architecture provides additional compute power
- Can run as either worker or root node
- May require different compilation flags

## Model Management

- Models stored in shared NFS directory for cluster-wide access
- Supports Llama and Qwen3 model architectures
- Handles both quantized (q40) and full-precision (f32) models
- Automatic model download and conversion utilities

## Integration

- Integrates with Consul service registry for node discovery
- Uses cluster networking configuration (10.4.0.0/20)
- Leverages NFS shared storage for model distribution
- Compatible with existing systemd service management
- Works alongside Ray, Slurm, and other compute frameworks

## Security Considerations

- Service runs as dedicated user account
- Network communication secured within cluster CIDR
- Model files protected with appropriate permissions
- Integration with Step-CA for TLS certificates (future enhancement)

## Performance Optimization

- Optimized for Pi cluster hardware (ARM64 + limited RAM)
- Automatic thread count detection based on CPU cores
- Memory usage distributed across multiple nodes
- High-speed Ethernet synchronization between nodes