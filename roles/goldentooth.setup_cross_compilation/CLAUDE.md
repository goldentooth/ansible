# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_cross_compilation role.

## Overview

This role sets up Velaryon (x86_64 GPU node) to use the containerized cross-compilation toolkit for building ARM64 binaries. It leverages the goldentooth/cross-compile-toolkit repository for consistent, reproducible builds targeting Raspberry Pi deployment.

## Purpose

- Deploy containerized cross-compilation environment on Velaryon
- Pull and configure cross-compilation containers from GitHub registry
- Set up local artifact storage and management
- Provide automated build workflows for cluster software
- Enable easy cross-compilation without host system pollution

## Architecture Change

**Previous Approach**: Direct installation of toolchains on Velaryon
- Complex dependency management
- Host system pollution with build tools
- Version conflicts and cleanup issues

**New Approach**: Containerized build system
- Isolated build environments in containers
- Clean host system with only Docker required
- Reproducible builds across different machines
- Easy updates via container image pulls

## Key Features

### Container-Based Cross-Compilation
- Pre-built containers with all cross-compilation tools
- Isolated build environments for different projects
- Easy scaling to multiple build machines
- Consistent build results across environments

### GitHub Integration
- Containers built via GitHub Actions CI/CD
- Pre-built images available from GitHub Container Registry
- Automatic updates when cross-compile-toolkit repository changes
- Community contributions and improvements

### Simplified Management
- No host toolchain installation required
- Docker-based orchestration via docker-compose
- Simple make targets for common operations
- Automated artifact collection and storage

## Files

- `tasks/main.yaml`: Main setup tasks
- `tasks/containers.yaml`: Container deployment and configuration
- `tasks/artifacts.yaml`: Artifact storage setup
- `templates/docker-compose.override.yml.j2`: Local configuration override
- `defaults/main.yaml`: Default configuration variables

## Dependencies

### System Requirements
- Velaryon node with Docker Engine installed
- Sufficient disk space for container images and build cache (50GB+)
- Internet connectivity for container registry access

### External Dependencies
- goldentooth/cross-compile-toolkit repository
- GitHub Container Registry access
- Docker Engine 20.10+ with buildx support

## Variables

### Container Configuration
```yaml
cross_compile:
  toolkit_repo: "https://github.com/goldentooth/cross-compile-toolkit.git"
  registry: "ghcr.io/goldentooth"
  
  containers:
    base_builder: "base-builder:latest"
    envoy_builder: "envoy-builder:latest"
    ci_builder: "ci-builder:latest"
  
  artifacts_dir: "/opt/goldentooth/artifacts"
  cache_dir: "/opt/goldentooth/build-cache"
  workspace_dir: "/opt/goldentooth/workspace"
```

### Build Configuration
```yaml
envoy_build:
  version: "v1.32.0"
  memory_allocator: "disabled"  # Raspberry Pi compatible
  build_config: "release"
  parallel_jobs: 8
  create_deb_package: true
```

## Usage

Deploy cross-compilation capabilities to Velaryon:
```yaml
- hosts: velaryon
  roles:
    - { role: 'goldentooth.setup_cross_compilation' }
```

Build Envoy for ARM64:
```bash
# Via goldentooth CLI
goldentooth build_envoy_arm64

# Via make in cross-compile-toolkit
goldentooth command velaryon 'cd /opt/goldentooth/workspace/cross-compile-toolkit && make envoy-build'

# Direct Docker execution
goldentooth command velaryon 'docker run --rm -v /opt/goldentooth/artifacts:/artifacts ghcr.io/goldentooth/envoy-builder:latest'
```

## Integration

### With Existing Roles
- **goldentooth.setup_docker**: Ensures Docker is installed and configured
- **goldentooth.setup_envoy**: Updated to use cross-compiled binaries from artifacts
- **goldentooth.setup_consul**: Envoy integration for service mesh

### Build Artifacts Management
- Cross-compiled binaries stored in `/opt/goldentooth/artifacts/`
- Automatic artifact collection from container builds
- Integration with deployment playbooks
- Checksum verification and build metadata

### Deployment Pipeline
1. Pull latest cross-compilation containers
2. Execute builds in isolated container environments
3. Collect artifacts from container volumes
4. Distribute artifacts to Pi nodes via existing mechanisms
5. Validate functionality with automated tests

## Container Workflow

### Initial Setup
1. Clone cross-compile-toolkit repository locally
2. Pull pre-built containers from GitHub Container Registry
3. Configure docker-compose with local overrides
4. Set up artifact and cache directories

### Building Software
1. Run containers with mounted volumes for artifacts
2. Execute builds inside isolated container environments
3. Collect build outputs to persistent storage
4. Verify build artifacts and generate metadata

### Updates and Maintenance
1. Pull latest container images periodically
2. Update local toolkit repository
3. Rebuild containers if needed for customizations
4. Clean up old build cache and artifacts

## Troubleshooting

### Common Issues
- **Container pull failures**: Check GitHub Container Registry access
- **Build failures**: Review container logs and build environment
- **Storage issues**: Monitor disk space for artifacts and cache

### Debug Commands
```bash
# Check container status
goldentooth command velaryon 'docker ps -a'

# View container logs
goldentooth command velaryon 'docker logs goldentooth-envoy-builder'

# Test cross-compilation environment
goldentooth command velaryon 'cd /opt/goldentooth/workspace/cross-compile-toolkit && make test'

# Manual container debugging
goldentooth command velaryon 'docker run -it --rm ghcr.io/goldentooth/base-builder:latest /bin/bash'
```

## Security Considerations

- Containers run with restricted privileges
- No direct host toolchain installation
- Build artifacts isolated from host system
- Container images signed and scanned for vulnerabilities
- Registry access via GitHub authentication

## Performance Notes

- Container startup overhead minimal compared to build time
- Build cache persists between container runs
- Parallel builds limited by container resource allocation
- Network bandwidth affects container image pulls and dependency downloads

## Migration from Previous Approach

For clusters upgrading from direct toolchain installation:

1. **Clean up old toolchains**: Remove existing cross-compilation tools
2. **Install containerized approach**: Deploy this updated role
3. **Migrate build scripts**: Update to use containerized builds
4. **Validate artifacts**: Ensure new builds work correctly on Pi nodes
5. **Update documentation**: Reflect new container-based workflow