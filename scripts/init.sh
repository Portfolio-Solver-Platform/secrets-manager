# Initialize Vault and save keys

set -e  # Exit on error

# Default path for dev environment
DEFAULT_DEV_PATH="$HOME/.psp/secrets-manager/keys.txt"

# Check if environment argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <environment> [keys-file]"
    echo "  environment: 'dev' or 'prod'"
    echo "  keys-file: path to save keys file (optional for dev, defaults to $DEFAULT_DEV_PATH)"
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

# Get directory from file path and create it
INIT_DIR=$(dirname "$INIT_FILE")
mkdir -p "$INIT_DIR"

echo "Environment: $ENVIRONMENT"
echo "Initializing Vault and saving keys to: $INIT_FILE"
echo "========================================="

function kube_exec {
    kubectl exec -n secrets-manager secrets-manager-openbao-0 -- "$@"
}

# Initialize vault and save output
kube_exec bao operator init > "$INIT_FILE"

echo "========================================="
echo "Vault initialized successfully!"
echo "Keys saved to: $INIT_FILE"
