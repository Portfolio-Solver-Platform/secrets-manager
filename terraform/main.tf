terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.4.0"
    }
  }
}

provider "vault" {
  address = var.url
  token = var.token
  token_name = var.token_name
}
