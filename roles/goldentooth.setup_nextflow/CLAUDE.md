# CLAUDE.md

## Overview

The `goldentooth.setup_nextflow` role installs and configures Nextflow workflow management system for seamless integration with the Slurm cluster. Nextflow enables scalable and reproducible scientific workflows using software containers.

## Purpose

- Install Nextflow workflow management system on shared NFS storage
- Configure Slurm executor for distributed job execution
- Set up Singularity container integration
- Provide example pipelines and documentation
- Create Lmod module for easy environment management

## File Structure

```
goldentooth.setup_nextflow/
├── tasks/
│   └── main.yaml              # Installation and configuration tasks
├── templates/
│   ├── nextflow.config.j2     # Slurm executor configuration
│   ├── nextflow-wrapper.sh.j2 # Environment wrapper script
│   └── hello-world.nf.j2      # Example pipeline
└── CLAUDE.md                  # This documentation
```

## Key Features

### Slurm Integration
- **Executor Configuration**: Native Slurm executor with queue management
- **Job Submission**: Automatic job submission with proper resource allocation
- **Error Handling**: Configurable retry policies and error strategies
- **Resource Profiles**: Predefined profiles for different workload types

### Container Support
- **Singularity Integration**: Automatic container pulling and caching
- **Shared Storage**: Container cache on NFS for cluster-wide access
- **Mount Configuration**: Automatic mounting of shared directories

### Workflow Management
- **Work Directory**: Centralized workspace on shared storage
- **Reporting**: Automatic generation of execution reports and timelines
- **Monitoring**: Integration with cluster monitoring systems
- **Cleanup**: Automatic cleanup of intermediate files

## Installation Details

### Prerequisites
- Java OpenJDK 17 (automatically installed)
- Slurm cluster (configured via goldentooth.setup_slurm_core)
- Singularity container runtime
- NFS shared storage mounted

### Software Versions
- **Nextflow**: {{ slurm.nextflow_version }} (configurable)
- **Java**: OpenJDK 17 LTS
- **Container Runtime**: Singularity 4.3.0+

### Installation Paths
- **Nextflow Binary**: `{{ slurm.nfs_base_path }}/nextflow/{{ slurm.nextflow_version }}/`
- **Configuration**: `{{ slurm.nfs_base_path }}/nextflow/{{ slurm.nextflow_version }}/nextflow.config`
- **Examples**: `{{ slurm.nfs_base_path }}/nextflow/{{ slurm.nextflow_version }}/examples/`
- **Workspace**: `{{ slurm.nfs_base_path }}/nextflow/workspace/`

## Configuration

### Slurm Executor Settings
```groovy
process {
    executor = 'slurm'
    queue = 'general'
    cpus = 1
    memory = '1GB'
    time = '1h'
    container = 'ubuntu:20.04'
}
```

### Resource Profiles
- **small**: 1 CPU, 2GB RAM, 30min
- **medium**: 2 CPUs, 4GB RAM, 2h
- **large**: 4 CPUs, 8GB RAM, 6h
- **gpu**: GPU queue with GRES allocation

### Execution Profiles
- **dev**: Development with reduced resources
- **prod**: Production with full retry logic
- **debug**: Verbose logging and reporting

## Usage Examples

### Basic Usage
```bash
# Load Nextflow module
module load Nextflow/24.10.0

# Run hello world example
nextflow run /mnt/nfs/slurm/nextflow/24.10.0/examples/hello-world.nf

# Run with development profile
nextflow run pipeline.nf -profile dev

# Run with custom resources
nextflow run pipeline.nf --process.cpus 4 --process.memory 8GB
```

### Advanced Usage
```bash
# Run with custom configuration
nextflow run pipeline.nf -c custom.config

# Run with specific work directory
nextflow run pipeline.nf -w /mnt/nfs/slurm/nextflow/workspace/project1

# Run with container override
nextflow run pipeline.nf --container ubuntu:22.04
```

## Integration Points

### Lmod Module System
- **Module File**: `Nextflow/{{ slurm.nextflow_version }}.lua`
- **Dependencies**: Automatic Java module loading
- **Environment**: Pre-configured NXF_* environment variables

### Slurm Integration
- **Queue Selection**: Automatic queue assignment based on resource requirements
- **Job Naming**: Descriptive job names with task hashes
- **Output Files**: Organized log files in workspace directory

### Container Registry
- **Singularity Cache**: Shared container cache for efficient reuse
- **Registry Access**: Docker Hub and other registries via Singularity
- **Local Containers**: Support for locally built containers

## Monitoring and Reporting

### Execution Reports
- **HTML Report**: Detailed execution statistics and resource usage
- **Timeline**: Visual timeline of task execution
- **Trace**: Machine-readable execution trace
- **DAG**: Pipeline dependency graph

### Integration with Cluster Monitoring
- **Prometheus Metrics**: Automatic export of pipeline metrics
- **Grafana Dashboards**: Visualization of workflow execution
- **Alerting**: Integration with cluster alerting systems

## Security Considerations

### File Permissions
- **NFS Security**: Proper ownership and permissions on shared storage
- **Container Security**: Singularity runs in user namespace
- **Job Security**: Slurm job isolation and resource limits

### Network Security
- **Container Networking**: Isolated container networking
- **Registry Access**: Secure container registry authentication
- **Data Privacy**: Encrypted data transfer where applicable

## Troubleshooting

### Common Issues
- **Java Not Found**: Ensure Java 17 is installed and JAVA_HOME is set
- **Permission Denied**: Check NFS mount permissions and ownership
- **Container Pull Failures**: Verify internet connectivity and registry access

### Debug Commands
```bash
# Check Nextflow installation
nextflow -version

# Test Slurm integration
sinfo -s

# Verify container runtime
singularity --version

# Check module availability
module avail Nextflow
```

### Log Locations
- **Nextflow Logs**: `{{ slurm.nfs_base_path }}/nextflow/workspace/nextflow.log`
- **Slurm Logs**: `{{ slurm.nfs_base_path }}/nextflow/workspace/slurm-*.out`
- **Container Logs**: Within individual task work directories

## Dependencies

- **Java OpenJDK 17**: Required runtime for Nextflow
- **Slurm**: Job scheduler and resource manager
- **Singularity**: Container runtime for reproducible environments
- **NFS**: Shared storage for workspace and containers
- **Lmod**: Environment module system

## Future Enhancements

- **GPU Support**: Enhanced GPU resource allocation and monitoring
- **Cloud Integration**: Support for cloud container registries
- **Pipeline Templates**: Additional example pipelines for common use cases
- **Performance Optimization**: Tuning for cluster-specific optimizations