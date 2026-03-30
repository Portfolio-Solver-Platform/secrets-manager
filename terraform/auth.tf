resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "k8s_config" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default.svc.cluster.local"
}

resource "vault_kubernetes_auth_backend_role" "tf_controller_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "tf-controller-role"
  bound_service_account_names      = ["tf-runner"]
  bound_service_account_namespaces = ["flux-system"]
  token_policies                   = ["flux-admin-policy"]
  token_ttl                        = 600 # 10 minutes
}

data "vault_policy_document" "flux_admin_rules" {
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

resource "vault_policy" "flux_admin" {
  name   = "flux-admin-policy"
  policy = data.vault_policy_document.flux_admin_rules.hcl
}
