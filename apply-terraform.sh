#!/usr/bin/env bash

if [ "$1" = "dev" ]; then
  echo "Using default development options, unless overridden by environment variables..."

  ENVIRONMENT="${ENVIRONMENT:-dev}"
  ROOT_TOKEN="${ROOT_TOKEN:-"root"}"
  SECRETS_MANAGER_URL="${SECRETS_MANAGER_URL:-http://secrets.local}"
  TOKEN_NAME="${TOKEN_NAME:-dev-terraform}"
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
