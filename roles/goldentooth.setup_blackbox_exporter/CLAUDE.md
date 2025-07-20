# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.setup_blackbox_exporter role.

## Purpose and Overview

The `goldentooth.setup_blackbox_exporter` role deploys and configures Prometheus Blackbox Exporter on the cluster to provide HTTP, HTTPS, TCP, and DNS endpoint monitoring. This fills a critical gap in the observability stack by adding synthetic monitoring capabilities for service availability and health checking.

## Key Features

- **Comprehensive Endpoint Monitoring**: Monitors 40+ critical cluster endpoints including HashiCorp services, Kubernetes APIs, node homepages, and external dependencies
- **Intelligent Probe Modules**: Separate configurations for internal TLS (Step-CA validation), external TLS, HTTP, TCP, and DNS monitoring
- **Step-CA Integration**: Full TLS encryption using existing cluster certificate authority
- **Service Discovery Integration**: Automatic target generation that integrates with Prometheus file-based service discovery
- **High Availability**: Deployed on `allyrion` alongside Prometheus for network proximity and reliability

## File Structure

```
goldentooth.setup_blackbox_exporter/
├── tasks/
│   └── main.yaml                    # Main deployment tasks
├── templates/
│   ├── blackbox.service.j2          # Systemd service configuration
│   ├── blackbox.yaml.j2             # Blackbox exporter configuration
│   ├── blackbox_targets.yaml.j2     # Service discovery targets
│   └── nginx-blackbox.conf.j2       # Nginx reverse proxy configuration
├── handlers/
│   └── main.yaml                    # Service restart handlers
└── CLAUDE.md                        # This documentation file
```

## Dependencies

- **Step-CA**: Certificate management for TLS encryption
- **Prometheus**: Metrics collection and storage
- **Nginx**: Reverse proxy for external access (optional)
- **Systemd**: Service management

## Target Categories

### Internal HTTPS Services (Step-CA validation)
- Consul Web UI (https://consul.goldentooth.net:8501)
- Vault Web UI (https://vault.goldentooth.net:8200)
- Nomad Web UI (https://nomad.goldentooth.net:4646)
- Grafana Dashboard (https://grafana.goldentooth.net:3000)
- Argo CD Web UI (https://argocd.goldentooth.net)
- Loki API (https://loki.goldentooth.net:3100)

### Internal HTTP Services
- Prometheus Web UI (http://prometheus.goldentooth.net:9090)
- Node homepages (http://[node].nodes.goldentooth.net)
- HAProxy statistics (http://allyrion:8404/stats)

### External HTTPS Services
- CloudFront distributions (https://clearbrook.goldentooth.net, https://home-proxy.goldentooth.net)

### TCP Services
- Consul API (consul.goldentooth.net:8500)
- Vault cluster communication (vault.goldentooth.net:8201)
- Step-CA server (jast:9443)
- Kubernetes API via HAProxy (allyrion:6443)

### DNS Resolution
- Core cluster domains (goldentooth.net, services.goldentooth.net, nodes.goldentooth.net)

## Configuration Variables

The role uses these key variables from `inventory/group_vars/all/vars.yaml`:

- `blackbox_exporter_version`: Version of blackbox exporter to install
- `blackbox_exporter_port`: Port for blackbox exporter (default: 9115)
- `prometheus_config_dir`: Prometheus configuration directory
- `step_ca_cert_path`: Path to cluster CA certificate

## Key Templates

### blackbox.yaml.j2
Defines probe modules for different endpoint types:
- `http_2xx`: Standard HTTP checking
- `https_2xx_internal`: HTTPS with Step-CA validation
- `https_2xx_external`: HTTPS with public CA validation
- `tcp_connect`: TCP port connectivity
- `dns_query`: DNS resolution checking

### blackbox_targets.yaml.j2
Generates Prometheus service discovery targets organized by probe module and service category.

### blackbox.service.j2
Systemd service configuration with TLS certificate paths and security settings.

## Integration Points

### Prometheus Integration
- Service discovery targets in `/etc/prometheus/file_sd/blackbox_targets.yaml`
- Automatic scrape configuration for all probe modules
- Metrics available at `probe_*` namespace

### Grafana Integration
- Metrics available for dashboard creation
- SLA tracking capabilities
- Certificate expiry monitoring

### Step-CA Integration
- TLS client certificate for secure communication
- CA certificate validation for internal services
- Automatic certificate renewal via systemd timers

## Security Considerations

- **TLS Encryption**: All communications encrypted using Step-CA certificates
- **Least Privilege**: Service runs with minimal required permissions
- **Network Security**: Only necessary ports exposed
- **Certificate Validation**: Proper CA validation for internal vs external services

## Usage Examples

```bash
# Deploy blackbox exporter
goldentooth setup_blackbox_exporter

# Check blackbox exporter status
goldentooth command allyrion "systemctl status blackbox-exporter"

# View blackbox exporter configuration
goldentooth command allyrion "cat /etc/blackbox-exporter/blackbox.yaml"

# Test specific probe
curl "http://allyrion:9115/probe?target=https://consul.goldentooth.net:8501&module=https_2xx_internal"
```

## Monitoring Capabilities

After deployment, the blackbox exporter provides:

- **Service Availability**: HTTP/HTTPS response codes and timing
- **Certificate Monitoring**: TLS certificate expiry and validity
- **DNS Health**: Resolution time and accuracy
- **Network Connectivity**: TCP port reachability
- **SLA Tracking**: Service uptime and response time metrics

## Troubleshooting

Common issues and solutions:

- **Certificate Errors**: Verify Step-CA certificate renewal
- **DNS Resolution**: Check cluster DNS configuration
- **Network Connectivity**: Verify firewall and routing
- **Service Discovery**: Check Prometheus target generation

This role provides comprehensive endpoint monitoring to complement the existing infrastructure monitoring stack, ensuring complete visibility into service health and availability across the Goldentooth cluster.