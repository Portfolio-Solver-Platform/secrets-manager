terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "vault" {
  address = var.url

  token_name = var.token_name
  token = var.token != "" ? var.token : null

  skip_child_token = true

  dynamic "auth_login" {
    for_each = var.token == "" ? [1] : []
    content {
      path = "auth/kubernetes/login"
      parameters = {
        role = local.tofu_runner_secrets_manager_role_name
        jwt  = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
      }
    }
  }
}
