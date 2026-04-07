
variable "solver_director_database_username" {
  type        = string
  default     = "solver-director"
}

variable "solver_director_database_password" {
  description = "If not set, a password will be generated."
  type        = string
  default     = null
  sensitive   = true
  ephemeral   = true
}


resource "vault_kubernetes_auth_backend_role" "solver_director" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "solver-director-role"
  bound_service_account_names      = ["solver-director"]
  bound_service_account_namespaces = ["psp"]
  token_policies                   = [vault_policy.solver_director_database_credentials.name]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "solver_director_db" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "solver-director-db-role"
  bound_service_account_names      = ["solver-director-db"]
  bound_service_account_namespaces = ["psp"]
  token_policies                   = [vault_policy.solver_director_database_credentials.name]
  token_ttl                        = 3600
}

ephemeral "random_password" "solver_director_database" {
  length  = 24
  special = false
}

resource "vault_kv_secret_v2" "solver_director_database_credentials" {
  mount = local.mounts.kv.path
  name  = "solver-director/database-credentials"

  data_json_wo = jsonencode({
    username = var.solver_director_database_username
    password = var.solver_director_database_password != null ? var.solver_director_database_password : ephemeral.random_password.solver_director_database.result
  })
  data_json_wo_version = 1
}

data "vault_policy_document" "solver_director_database_credentials_rules" {
  rule {
    path         = "kv/data/solver-director/database-credentials"
    capabilities = ["read"]
  }
}

resource "vault_policy" "solver_director_database_credentials" {
  name   = "solver-director-database-credentials-policy"
  policy = data.vault_policy_document.solver_director_database_credentials_rules.hcl
}

