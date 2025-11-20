#!/usr/bin/env bash

if [ "$1" = "dev" ]; then
  echo "Using default development options, unless overridden by environment variables..."

  ENVIRONMENT="${ENVIRONMENT:-dev}"
  ROOT_TOKEN="${ROOT_TOKEN:-""}"
  ROOT_TOKEN_PATH="${ROOT_TOKEN_PATH:-./.cache/keys.txt}"
  SECRETS_MANAGER_URL="${SECRETS_MANAGER_URL:-http://secrets.local}"
  TOKEN_NAME="${TOKEN_NAME:-dev-terraform}"
  JWT_ISSUER="${JWT_ISSUER:-http://keycloak.local:8080/realms/psp}"
  JWKS_URL="${JWKS_URL:-http://keycloak-service.keycloak.svc.cluster.local:8080/realms/psp/protocol/openid-connect/certs}"
fi

if [ -z "$ROOT_TOKEN" ]; then
  if [ -n "$ROOT_TOKEN_PATH" ]; then
    if [ -f "$ROOT_TOKEN_PATH" ]; then
      ROOT_TOKEN=$(grep "Initial Root Token: " "$ROOT_TOKEN_PATH" | awk '{print $4}')
    else
      echo "Error: ROOT_TOKEN_PATH is set to '$ROOT_TOKEN_PATH', but the file does not exist."
      exit 1
    fi
  fi
fi

if [ -z "$ROOT_TOKEN" ]; then
    echo "ROOT_TOKEN is not set. Please set it or provide a valid ROOT_TOKEN_PATH."
    exit 1
fi

terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve \
    -var "environment=$ENVIRONMENT"\
    -var "url=$SECRETS_MANAGER_URL"\
    -var "token=$ROOT_TOKEN"\
    -var "token_name=$TOKEN_NAME"\
    -var "jwt_issuer=$JWT_ISSUER"\
    -var "jwks_url=$JWKS_URL"\
