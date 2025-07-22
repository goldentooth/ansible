# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Goldentooth cluster test automation scripts.

## Overview

The `/ansible/tests/scripts/` directory contains shell scripts for automating test execution, scheduling, and integration with system services. These scripts provide direct access to testing functionality outside of the main `goldentooth` CLI interface.

## Script Overview

### `run_tests.sh` - Direct Test Execution

**Purpose**: Shell script wrapper for running Ansible test playbooks directly without requiring the goldentooth CLI.

**Usage**:
```bash
# Run all tests
./run_tests.sh all

# Run specific test categories
./run_tests.sh system
./run_tests.sh consul  
./run_tests.sh kubernetes
./run_tests.sh vault
./run_tests.sh step_ca

# Quick system checks only
./run_tests.sh quick
```

**Features**:
- **Environment Setup**: Automatically configures Ansible environment variables
- **Vault Integration**: Handles encrypted vault password if configured
- **Output Formatting**: Provides consistent logging and result reporting
- **Error Handling**: Graceful failure handling and exit codes
- **Performance Timing**: Reports test execution duration

**Implementation Pattern**:
```bash
#!/bin/bash
set -euo pipefail

# Configuration
ANSIBLE_DIR="../"
INVENTORY="$ANSIBLE_DIR/inventory/hosts"
VAULT_PASSWORD_FILE="$HOME/.goldentooth_vault_password"

# Test category mapping
case "$1" in
  "all")     PLAYBOOK="test_all.yaml" ;;
  "quick")   PLAYBOOK="test_system.yaml" ;;
  "step_ca") PLAYBOOK="test_step_ca.yaml" ;;
  *)         echo "Unknown test: $1"; exit 1 ;;
esac

# Execute with proper environment
cd "$(dirname "$0")/../playbooks"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" "$@"
```

### `setup_cron.sh` - Automated Test Scheduling

**Purpose**: Configure system cron jobs for automated cluster health testing.

**Functionality**:
- **Cron Installation**: Creates appropriate crontab entries for test automation
- **Frequency Configuration**: Configurable test intervals (default: every 15 minutes)
- **Result Management**: Handles log rotation and cleanup
- **Service Integration**: Coordinates with Prometheus metric collection

**Usage**:
```bash
# Interactive setup with prompts
./setup_cron.sh

# Non-interactive with defaults
./setup_cron.sh --auto

# Remove existing cron entries
./setup_cron.sh --remove

# Show current configuration
./setup_cron.sh --show
```

**Default Cron Schedule**:
```cron
# Goldentooth cluster health tests
*/15 * * * * /path/to/goldentooth/ansible/tests/scripts/run_tests.sh quick >> /var/log/goldentooth-tests.log 2>&1
0 */6 * * * /path/to/goldentooth/ansible/tests/scripts/run_tests.sh all >> /var/log/goldentooth-tests.log 2>&1
```

**Configuration Options**:
- **Test Frequency**: Adjustable intervals for different test types
- **Log Management**: Rotation and retention policies
- **User Context**: Run as specific user with appropriate permissions
- **Environment Variables**: Set required Ansible and cluster variables

## Integration Patterns

### Environment Setup
Both scripts handle consistent environment configuration:

```bash
# Ansible configuration
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_CONFIG="$SCRIPT_DIR/../ansible.cfg"

# Goldentooth-specific settings
export GOLDENTOOTH_ANSIBLE_PATH="$SCRIPT_DIR/../"
export GOLDENTOOTH_VAULT_PASSWORD_FILE="$HOME/.goldentooth_vault_password"

# Performance optimization
export ANSIBLE_PIPELINING=True
export ANSIBLE_SSH_PIPELINING=True
```

### Logging and Output Management

#### Log Structure
```bash
# Structured logging format
LOG_PREFIX="[$(date +'%Y-%m-%d %H:%M:%S')] goldentooth-tests"
echo "$LOG_PREFIX Starting test execution: $TEST_TYPE"

# Result logging
if [ $? -eq 0 ]; then
    echo "$LOG_PREFIX Test completed successfully in ${duration}s"
else
    echo "$LOG_PREFIX Test failed with exit code $?"
fi
```

#### Log Rotation
```bash
# Automatic log rotation in cron setup
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE") -gt 10485760 ]; then
    mv "$LOG_FILE" "${LOG_FILE}.old"
    touch "$LOG_FILE"
fi
```

### Error Handling and Recovery

#### Graceful Failures
```bash
# Continue testing other categories on individual failures
for test_category in $TEST_CATEGORIES; do
    if ! ./run_tests.sh "$test_category"; then
        echo "WARNING: $test_category tests failed, continuing..."
        FAILED_TESTS="$FAILED_TESTS $test_category"
    fi
done
```

#### Notification Integration
```bash
# Optional notification on test failures
if [ -n "$FAILED_TESTS" ]; then
    echo "Failed tests: $FAILED_TESTS" | mail -s "Goldentooth Test Failures" admin@cluster.local
fi
```

## Customization and Extensions

### Adding New Test Scripts

1. **Follow Naming Convention**: `<purpose>_tests.sh`
2. **Use Standard Environment**: Source common environment setup
3. **Implement Consistent Logging**: Use structured log format
4. **Handle Errors Gracefully**: Continue testing on individual failures
5. **Document Usage**: Include help text and examples

### Custom Scheduling

#### Alternative Schedulers
```bash
# Systemd timer integration
# /etc/systemd/system/goldentooth-tests.service
[Unit]
Description=Goldentooth Cluster Health Tests
After=network.target

[Service]
Type=oneshot
ExecStart=/path/to/tests/scripts/run_tests.sh all
User=goldentooth

# /etc/systemd/system/goldentooth-tests.timer
[Unit]
Description=Run Goldentooth tests every 15 minutes
Requires=goldentooth-tests.service

[Timer]
OnCalendar=*:0/15
Persistent=true

[Install]
WantedBy=timers.target
```

#### Custom Test Intervals
Modify `setup_cron.sh` to support different schedules:
```bash
# Environment-specific intervals
case "$ENVIRONMENT" in
    "production")
        QUICK_INTERVAL="*/15"  # Every 15 minutes
        FULL_INTERVAL="0 */4"  # Every 4 hours
        ;;
    "staging")
        QUICK_INTERVAL="*/5"   # Every 5 minutes  
        FULL_INTERVAL="0 */2"  # Every 2 hours
        ;;
esac
```

### Integration with External Systems

#### Metric Export Enhancement
```bash
# Additional metric export beyond Prometheus textfiles
if [ "$EXPORT_METRICS" = "true" ]; then
    # Export to external monitoring systems
    curl -X POST "$METRICS_ENDPOINT" -d @/tmp/test_results.json
fi
```

#### Alert Integration
```bash
# Direct alerting on critical test failures
if grep -q "critical.*failed" "$LOG_FILE"; then
    echo "Critical test failure detected" | \
        /usr/local/bin/alert_manager_webhook
fi
```

## Deployment and Maintenance

### Installation Process
```bash
# Make scripts executable
chmod +x *.sh

# Setup cron automation
./setup_cron.sh --auto

# Verify installation
./run_tests.sh quick
```

### Maintenance Tasks
```bash
# Log cleanup (run monthly)
find /var/log -name "goldentooth-tests*.log*" -mtime +30 -delete

# Verify cron entries
crontab -l | grep goldentooth

# Test script functionality
./run_tests.sh --dry-run all
```

### Troubleshooting

#### Common Issues
- **Permission Errors**: Check script execution permissions and user context
- **Ansible Failures**: Verify inventory and vault password file access
- **Cron Issues**: Check user crontab vs system crontab installation
- **Log Rotation**: Ensure sufficient disk space and proper rotation

#### Debug Mode
```bash
# Enable verbose output
export GOLDENTOOTH_DEBUG=1
./run_tests.sh all

# Ansible verbose mode
export ANSIBLE_DEBUG=1
./run_tests.sh system
```

This script-based automation provides flexible, maintainable test scheduling while integrating smoothly with both the goldentooth CLI and system service management.