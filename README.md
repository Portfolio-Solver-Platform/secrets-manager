# Secrets Manager

This repository provides the secrets manager for PSP.

## Usage

For development, run `skaffold dev`. Then apply Terraform config using `./apply-terraform.sh dev`.

For production:
- The transit secrets manager (see that repository for steps) needs to be running.
- Create transit token secret using `./apply-transit-token-secret.sh <token>`.
- Deploy everything using infrastructure repo.
- For the first time setup, you need to start a shell in `secrets-manager-openbao-0` and execute `bao operator init`.
  This will present you with 5 recovery keys and a root key. These need to be saved because this is the only time you will be given them.

