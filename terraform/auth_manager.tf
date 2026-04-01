
resource "vault_kubernetes_auth_backend_role" "auth_manager_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "auth-manager-role"
  bound_service_account_names      = ["keycloak-operator"]
  bound_service_account_namespaces = ["keycloak"]
  token_policies                   = [
    vault_policy.auth_manager_bootstrap.name,
    vault_policy.auth_manager_bootstrap_service.name
  ]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "auth_manager_tofu_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "auth-manager-tofu-role"
  bound_service_account_names      = ["tofu-runner-auth-manager"]
  bound_service_account_namespaces = ["flux-system"]
  token_policies                   = [
    vault_policy.auth_manager_bootstrap_service.name,
    vault_policy.auth_manager_admin_app.name
  ]
  token_ttl                        = 3600
}

# Bootstrap admin
ephemeral "random_password" "auth_manager_bootstrap_admin" {
  length  = 24
  special = false
}

resource "vault_kv_secret_v2" "auth_manager_bootstrap_admin_credentials" {
  mount = local.mounts.kv.path
  name  = "auth-manager/bootstrap-admin-credentials"

  data_json_wo = jsonencode({
    username = var.auth_manager_bootstrap_admin_username
    password = var.auth_manager_bootstrap_admin_password != null ? var.auth_manager_bootstrap_admin_password : ephemeral.random_password.auth_manager_bootstrap_admin.result
  })
  data_json_wo_version = 1
}

data "vault_policy_document" "auth_manager_bootstrap_rules" {
  rule {
    path         = "kv/data/auth-manager/bootstrap-admin-credentials"
    capabilities = ["read"]
  }
}

resource "vault_policy" "auth_manager_bootstrap" {
  name   = "auth-manager-bootstrap-policy"
  policy = data.vault_policy_document.auth_manager_bootstrap_rules.hcl
}

# Bootstrap service
ephemeral "random_password" "auth_manager_bootstrap_service" {
  length  = 64
  special = false
}

resource "vault_kv_secret_v2" "auth_manager_bootstrap_service_credentials" {
  mount = local.mounts.kv.path
  name  = "auth-manager/bootstrap-service-credentials"

  data_json_wo = jsonencode({
    clientId = var.auth_manager_bootstrap_service_id
    clientSecret = var.auth_manager_bootstrap_service_secret != null ? var.auth_manager_bootstrap_service_secret : ephemeral.random_password.auth_manager_bootstrap_service.result
  })
  data_json_wo_version = 1
}

data "vault_policy_document" "auth_manager_bootstrap_service_rules" {
  rule {
    path         = "kv/data/auth-manager/bootstrap-service-credentials"
    capabilities = ["read"]
  }
}

resource "vault_policy" "auth_manager_bootstrap_service" {
  name   = "auth-manager-bootstrap-service-policy"
  policy = data.vault_policy_document.auth_manager_bootstrap_service_rules.hcl
}

# Admin app secret
ephemeral "random_password" "auth_manager_admin_app" {
  length  = 64
  special = false
}

resource "vault_kv_secret_v2" "auth_manager_admin_app_credentials" {
  mount = local.mounts.kv.path
  name  = "auth-manager/admin-app-credentials"

  data_json_wo = jsonencode({
    secret = var.auth_manager_admin_app_secret != null ? var.auth_manager_admin_app_secret : ephemeral.random_password.auth_manager_admin_app.result
  })
  data_json_wo_version = 1
}

data "vault_policy_document" "auth_manager_admin_app_rules" {
  rule {
    path         = "kv/data/auth-manager/admin-app-credentials"
    capabilities = ["read"]
  }
}

resource "vault_policy" "auth_manager_admin_app" {
  name   = "auth-manager-admin-app-policy"
  policy = data.vault_policy_document.auth_manager_admin_app_rules.hcl
}


