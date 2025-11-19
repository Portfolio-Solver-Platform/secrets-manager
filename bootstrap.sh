#!/usr/bin/env bash
set -e
helm repo add openbao https://openbao.github.io/openbao-helm
kubectl apply -f ./namespace.yaml
