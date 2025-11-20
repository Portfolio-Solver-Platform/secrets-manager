
resource "vault_jwt_auth_backend" "psp" {
  path = "jwt"
  description = "Authenticate using a PSP JWT"

  jwks_url = var.jwks_url
  bound_issuer = var.jwt_issuer
  # bound_audiences = ["secrets-manager"] # TODO: Add this
}

locals {
  jwt_psp = vault_jwt_auth_backend.psp
}

resource "vault_jwt_auth_backend_role" "artifact-write" {
  backend         = local.jwt_psp.path
  role_name       = "artifact-write"
  token_policies  = ["default", "dev", "prod"]

  user_claim            = "sub"
  role_type             = "jwt"
  bound_claims = {
    scope = "artifact-registry:write"
  }
}

