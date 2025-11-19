#!/usr/bin/env bash

set -e  # Exit on error

./scripts/init.sh dev
./scripts/unseal.sh dev
