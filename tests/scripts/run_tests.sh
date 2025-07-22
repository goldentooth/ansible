#!/bin/bash
# Goldentooth test runner

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default values
TEST_SUITE="all"
TAGS=""
VERBOSE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --suite)
            TEST_SUITE="$2"
            shift 2
            ;;
        --tags)
            TAGS="--tags $2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE="-vvv"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --suite SUITE    Test suite to run (all, consul, k8s, etc.)"
            echo "  --tags TAGS      Ansible tags to run"
            echo "  --verbose        Verbose output"
            echo "  --help           Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}Starting Goldentooth cluster tests...${NC}"
echo "Test suite: $TEST_SUITE"
echo "Time: $(date)"
echo "----------------------------------------"

# Run the tests
cd "$TEST_DIR"

if ansible-playbook $VERBOSE $TAGS "playbooks/test_${TEST_SUITE}.yaml"; then
    echo -e "\n${GREEN}✓ Tests completed successfully${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Tests failed${NC}"
    exit 1
fi