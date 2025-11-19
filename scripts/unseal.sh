#!/usr/bin/env bash

# Unseal Vault using keys from init output file

set -e  # Exit on error

# Default path for dev environment
DEFAULT_DEV_PATH=".cache/keys.txt"

# Check if environment argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <environment> [keys-file]"
    echo "  environment: 'dev' or 'prod'"
    echo "  keys-file: path to keys file (optional for dev, defaults to $DEFAULT_DEV_PATH)"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Uses default dev path"
    echo "  $0 dev /path/to/keys.txt  # Uses custom path"
    echo "  $0 prod /path/to/keys.txt # Prod requires path"
    exit 1
fi

ENVIRONMENT="$1"

# Validate environment
if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "prod" ]; then
    echo "Error: Environment must be 'dev' or 'prod'"
    exit 1
fi

# Determine file path
if [ "$ENVIRONMENT" == "dev" ]; then
    INIT_FILE="${2:-$DEFAULT_DEV_PATH}"
else
    # prod requires explicit path
    if [ $# -lt 2 ]; then
        echo "Error: 'prod' environment requires a keys file path"
        echo "Usage: $0 prod <keys-file>"
        exit 1
    fi
    INIT_FILE="$2"
fi

# Check if file exists
if [ ! -f "$INIT_FILE" ]; then
    echo "Error: File '$INIT_FILE' not found!"
    exit 1
fi

echo "Environment: $ENVIRONMENT"
echo "Reading unseal keys from: $INIT_FILE"
echo "========================================="

# Extract unseal keys (first 3)
KEYS=$(grep "Unseal Key" "$INIT_FILE" | head -3 | awk '{print $NF}')

# Check if we found keys
if [ -z "$KEYS" ]; then
    echo "Error: No unseal keys found in file!"
    exit 1
fi

# Counter for display
counter=1

function kube_exec {
    kubectl exec -n secrets-manager secrets-manager-openbao-0 -- "$@"
}

# Unseal vault with each key
while IFS= read -r key; do
    echo "Unsealing with key $counter..."
    kube_exec bao operator unseal "$key"
    echo ""
    ((counter++))
done <<< "$KEYS"

echo "========================================="
echo "Vault unseal process complete!"
