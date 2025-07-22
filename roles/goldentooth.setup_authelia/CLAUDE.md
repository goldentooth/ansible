# goldentooth.setup_authelia

This role installs and configures Authelia authentication and authorization server on the Goldentooth cluster.

## Purpose

Authelia provides:
- Single Sign-On (SSO) authentication for cluster services
- Multi-factor authentication (MFA) with TOTP and WebAuthn
- Authorization policies for fine-grained access control
- OpenID Connect (OIDC) provider for OAuth2 integration
- Integration with external identity providers

## Dependencies

- Step-CA for certificate management (certificates will be generated)
- SQLite for local storage (or PostgreSQL for production)
- Nginx or similar reverse proxy (for TLS termination)

## Configuration

### Key Variables

- `authelia_version`: Authelia version to install (default: "4.38.10")
- `authelia_domain`: Base domain for the cluster (default: "goldentooth.net")
- `authelia_host`: Listen address (default: "0.0.0.0")
- `authelia_port`: HTTP port (default: 9091)
- `authelia_oidc_enabled`: Enable OIDC provider (default: true)

### Secrets

The following secrets should be defined in the vault:
- `vault_authelia_jwt_secret`: JWT signing secret
- `vault_authelia_session_secret`: Session encryption secret
- `vault_authelia_storage_encryption_key`: Database encryption key
- `vault_authelia_oidc_hmac_secret`: OIDC HMAC secret
- `vault_authelia_oidc_mcp_secret`: MCP client secret
- `vault_authelia_mcp_service_password`: Service account password

## Installation

### Default Installation
```bash
goldentooth setup_authelia
```

### Custom Target
```bash
goldentooth setup_authelia --limit authelia_server
```

## OIDC Integration

The role configures Authelia as an OIDC provider with a pre-configured client for the MCP server:

- **Client ID**: `goldentooth-mcp`
- **Grant Types**: `authorization_code`, `refresh_token`, `client_credentials`
- **Scopes**: `openid`, `profile`, `email`, `groups`
- **Authorization Policy**: `one_factor`

## Default Users

The role creates:
- **admin**: Administrator account (password: "authelia" - CHANGE IMMEDIATELY)
- **mcp-service**: Service account for MCP server automation

## Service Management

Authelia runs as a systemd service:
```bash
# Check status
goldentooth command authelia "systemctl status authelia"

# View logs
goldentooth command authelia "journalctl -u authelia -f"

# Restart service
goldentooth command_root authelia "systemctl restart authelia"
```

## Access URLs

- **Authentication Portal**: `https://auth.goldentooth.net:9091`
- **OIDC Discovery**: `https://auth.goldentooth.net:9091/.well-known/openid-configuration`
- **Metrics**: `http://auth.goldentooth.net:9959/metrics`

## Security Features

- Argon2id password hashing
- Session security with secure cookies
- Rate limiting and IP banning for failed attempts
- Security hardening via systemd service restrictions
- Automatic certificate generation for OIDC signing

## File Locations

- **Config**: `/etc/authelia/configuration.yml`
- **Users**: `/etc/authelia/users_database.yml`
- **Data**: `/var/lib/authelia/`
- **Logs**: `/var/log/authelia/`
- **Binary**: `/usr/local/bin/authelia`
- **Service**: `/etc/systemd/system/authelia.service`

## Integration with Other Services

### MCP Server OAuth2
The MCP server can use Authelia for authentication via OAuth2 client credentials flow:

1. MCP server authenticates with Authelia using client credentials
2. Receives access token with appropriate scopes
3. Validates tokens on subsequent requests

### Reverse Proxy Integration
For production deployment, configure nginx or HAProxy to:
- Terminate TLS
- Proxy requests to Authelia on port 9091
- Handle authentication redirects

## Troubleshooting

### Configuration Validation
```bash
goldentooth command authelia "/usr/local/bin/authelia validate-config --config /etc/authelia/configuration.yml"
```

### Database Issues
```bash
goldentooth command authelia "sqlite3 /var/lib/authelia/db.sqlite3 '.tables'"
```

### Certificate Problems
```bash
goldentooth command authelia "openssl x509 -in /etc/authelia/oidc.crt -text -noout"
```

## Production Considerations

1. **Replace SQLite**: Configure PostgreSQL for production workloads
2. **SMTP Notifications**: Configure real SMTP instead of filesystem notifications
3. **Redis Session Store**: Use Redis for session storage in HA deployments
4. **Change Default Passwords**: Update all default passwords before production
5. **TLS Termination**: Use reverse proxy with proper TLS certificates
6. **Backup Strategy**: Regular backups of SQLite database and certificates

## Related Documentation

- Official Authelia docs: https://www.authelia.com/docs/
- OIDC configuration: https://www.authelia.com/docs/configuration/identity-providers/oidc/
- Security considerations: https://www.authelia.com/docs/security/