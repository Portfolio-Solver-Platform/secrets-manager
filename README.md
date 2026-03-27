# Secrets Manager

This repository provides the secrets manager for PSP.

## Usage

For development, run `skaffold dev`.

For production:
- The transit secrets manager (see that repository for steps) needs to be running.
- If this is the first time you start it, create the Kubernetes secret for the vault token from the infrastructure repo (see init folder).
- Run `skaffold run -p prod`

For the first time setup, you need to start a shell in `secrets-manager-openbao-0` and execute `bao operator init`.
This will present you with 5 recovery keys. These need to be saved because this is the only time you will be given them.

