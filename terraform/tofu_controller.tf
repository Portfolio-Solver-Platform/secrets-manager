
resource "vault_kubernetes_auth_backend_role" "tofu_runner_secrets_manager_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "tofu-runner-secrets-manager-role"
  bound_service_account_names      = ["tofu-runner-secrets-manager"]
  bound_service_account_namespaces = ["flux-system"]
  token_policies                   = ["tofu-runner-secrets-manager-policy"]
  token_ttl                        = 600 # 10 minutes
}

data "vault_policy_document" "tofu_runner_secrets_manager_rules" {
  rule {
    path         = "sys/mounts/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/policies/acl/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/auth/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/health"
    capabilities = ["read", "sudo"]
  }
}

resource "vault_policy" "tofu_runner_secrets_manager" {
  name   = "tofu-runner-secrets-manager-policy"
  policy = data.vault_policy_document.tofu_runner_secrets_manager_rules.hcl
}
