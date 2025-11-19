# Secrets Manager

This repository provides the secrets manager for PSP.

## Usage

See [First Time Setup](#first-time-setup) if this is your first time setting it up.

First, run `skaffold dev`. Then, enter a shell in `secrets-manager-openbao-0`
and execute `vault operator unseal <key>` with 3 of your unseal keys.

### First Time Setup

For the first time setup, execute `bootstrap.sh`. Afterwards, you can use `skaffold dev`.
Then, you need to start a shell in `secrets-manager-openbao-0` and execute `vault operator init`.
This will present you with 5 unseal keys. These need to be saved because this is the only time you will be given them
and you will have to provide them every time you restart OpenBao.

Then, you need to unseal the secret storage by using `vault operator unseal <key>`
with 3 of the unseal keys you were given after the `init` command.

