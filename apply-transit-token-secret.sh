#!/usr/bin/env bash

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: ./apply-transit-token-secret.sh <vault_token>"
    exit 1
fi

export VAULT_TOKEN="$1"

echo "Applying secret to the cluster..."
helm template transit-secret ./helm \
    -n secrets-manager \
    -s templates/transit-secret.yaml \
    --set secretsManagerTransit.tokenSecret.enable=true \
    --set-string secretsManagerTransit.tokenSecret.value="$VAULT_TOKEN" \
    | kubectl apply -f -

