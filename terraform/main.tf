terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.8.0"
    }
  }
}

provider "vault" {
  address = var.url

  token_name = var.token_name
  token = var.token != "" ? var.token : null

  dynamic "auth_login" {
    for_each = var.token == "" ? [1] : []
    content {
      path = "auth/kubernetes/login"
      parameters = {
        role = "tf-controller-role"
        jwt  = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
      }
    }
  }
}
