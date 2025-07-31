# goldentooth.rotate_seaweedfs_certs

This role rotates TLS certificates for SeaweedFS services using Step-CA, ensuring secure communication for distributed storage.

## Purpose

- Rotate SeaweedFS TLS certificates for both master and volume servers
- Renew certificates before expiration using Step-CA
- Maintain secure SeaweedFS communication across the cluster
- Integrate with automated certificate renewal system

## Files

- `tasks/main.yaml`: Main certificate rotation tasks
- `handlers/main.yaml`: Service restart handlers

## Key Features

- **Certificate Generation**: Uses Step-CA to generate certificates with appropriate SANs
- **Service Integration**: Automatically restarts SeaweedFS services after certificate renewal
- **Security**: Proper file permissions and ownership for certificate files
- **Multiple SANs**: Supports hostname, FQDN, IP address, and localhost access

## Dependencies

- Requires Step-CA to be configured and running
- Depends on SeaweedFS services being installed
- Uses cluster-wide certificate renewal infrastructure
- Requires proper Step-CA provisioner configuration

## Variables

Key variables used:
- `seaweedfs.certs_path`: Directory for certificate storage
- `seaweedfs.uid/gid`: User/group for certificate ownership
- `step_ca.executable`: Path to step CLI tool
- `step_ca.default_provisioner`: Step-CA provisioner configuration
- `cluster_domain`: Domain for certificate SANs

## Certificate SANs

The generated certificates include these Subject Alternative Names:
- Node hostname (e.g., `fenn`)
- Service FQDN (e.g., `fenn.seaweedfs.storage.goldentooth.net`)
- Service domain (e.g., `seaweedfs.storage.goldentooth.net`)
- IP address of the node
- `localhost` and `127.0.0.1` for local access

## Usage

Typically called via certificate rotation playbook:
```bash
goldentooth rotate_seaweedfs_certs
```

Or as part of the main setup:
```yaml
- { role: 'goldentooth.rotate_seaweedfs_certs' }
```

## Integration

Works with:
- `goldentooth.setup_seaweedfs`: Main SeaweedFS setup role
- `goldentooth.setup_cluster_ca`: Certificate authority setup
- Certificate renewal system (`cert-renewer@seaweedfs.timer`)

## Security Considerations

- Certificates are valid for 24 hours to ensure regular rotation
- Private keys have restrictive permissions (0600)
- Services automatically restart to use new certificates
- Follows cluster-wide PKI security practices