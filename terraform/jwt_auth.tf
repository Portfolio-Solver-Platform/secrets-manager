
resource "vault_jwt_auth_backend" "psp" {
  path = "jwt"
  description = "Authenticate using a PSP JWT"

  jwks_url = var.jwks_url
  bound_issuer = var.jwt_issuer
  # bound_audiences = ["secrets-manager"] # TODO: Add this
}

locals {
  jwt_psp = vault_jwt_auth_backend.psp
  scope = "artifact-registry:write"
  secure_scopes = join(",", [local.scope, "${local.scope} *", "* ${local.scope}", "* ${local.scope} *"])
}

resource "vault_jwt_auth_backend_role" "artifact-write" {
  backend         = local.jwt_psp.path
  role_name       = "artifact-write"
  token_policies  = ["default", "dev", "prod"]

  user_claim            = "sub"
  role_type             = "jwt"
  bound_claims_type = "glob"
  bound_claims = {
    scope = local.secure_scopes
  }
}

