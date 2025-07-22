#!/bin/bash
# Setup automated test execution via cron

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"

# Create cron entries
cat > /tmp/goldentooth-tests-cron << 'EOF'
# Goldentooth Cluster Health Tests
# Run quick tests every 5 minutes
*/5 * * * * /usr/local/bin/goldentooth test quick --tags system > /var/log/goldentooth-tests/quick.log 2>&1

# Run full service tests every 15 minutes
*/15 * * * * /usr/local/bin/goldentooth test all > /var/log/goldentooth-tests/all.log 2>&1

# Run comprehensive tests hourly
0 * * * * /usr/local/bin/goldentooth test all --check > /var/log/goldentooth-tests/comprehensive.log 2>&1

# Clean up old metrics files daily
0 2 * * * find /var/lib/prometheus/node-exporter/ -name "goldentooth-tests.prom.*" -mtime +7 -delete
EOF

echo "Cron entries for automated testing:"
echo "===================================="
cat /tmp/goldentooth-tests-cron
echo ""
echo "To install, run:"
echo "  sudo mkdir -p /var/log/goldentooth-tests"
echo "  sudo crontab -l > /tmp/current-cron"
echo "  cat /tmp/goldentooth-tests-cron >> /tmp/current-cron"
echo "  sudo crontab /tmp/current-cron"
echo ""
echo "Or add to /etc/cron.d/goldentooth-tests"