
resource "vault_kubernetes_auth_backend_role" "monitoring_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "monitoring-role"
  bound_service_account_names      = ["monitoring-grafana"]
  bound_service_account_namespaces = ["monitoring"]
  token_policies                   = [vault_policy.monitoring_admin.name]
  token_ttl                        = 3600
}

# Bootstrap admin
ephemeral "random_password" "monitoring_admin" {
  length  = 24
  special = false
}

resource "vault_kv_secret_v2" "monitoring_admin_credentials" {
  mount = local.mounts.kv.path
  name  = "monitoring/admin-credentials"

  data_json_wo = jsonencode({
    username = var.monitoring_admin_username
    password = var.monitoring_admin_password != null ? var.monitoring_admin_password : ephemeral.random_password.monitoring_admin.result
  })
  data_json_wo_version = 1
}

data "vault_policy_document" "monitoring_admin_rules" {
  rule {
    path         = "kv/data/monitoring/admin-credentials"
    capabilities = ["read"]
  }
}

resource "vault_policy" "monitoring_admin" {
  name   = "monitoring-admin-policy"
  policy = data.vault_policy_document.monitoring_admin_rules.hcl
}

