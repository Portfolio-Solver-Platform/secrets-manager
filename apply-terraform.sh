#!/usr/bin/env bash

if [ "$1" = "dev" ]; then
  echo "Using default development options, unless overridden by environment variables..."

  ROOT_TOKEN="${ROOT_TOKEN:-"root"}"
  SECRETS_MANAGER_URL="${SECRETS_MANAGER_URL:-http://secrets.local}"
  TOKEN_NAME="${TOKEN_NAME:-dev-terraform}"
  AUTH_MANAGER_BOOTSTRAP_ADMIN_PASSWORD="${AUTH_MANAGER_BOOTSTRAP_ADMIN_PASSWORD:-admin}"
  AUTH_MANAGER_BOOTSTRAP_SERVICE_SECRET="${AUTH_MANAGER_BOOTSTRAP_SERVICE_SECRET:-admin}"
fi

if [ -z "$ROOT_TOKEN" ]; then
    echo "ROOT_TOKEN is not set. Please set it or provide a valid ROOT_TOKEN_PATH."
    exit 1
fi

terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve \
    -var "url=$SECRETS_MANAGER_URL"\
    -var "token=$ROOT_TOKEN"\
    -var "token_name=$TOKEN_NAME"\
    -var "auth_manager_bootstrap_admin_password=$AUTH_MANAGER_BOOTSTRAP_ADMIN_PASSWORD"\
    -var "auth_manager_bootstrap_service_secret=$AUTH_MANAGER_BOOTSTRAP_SERVICE_SECRET"\
