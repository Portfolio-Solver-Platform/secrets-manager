
resource "vault_jwt_auth_backend" "psp" {
  path = "jwt"
  description = "Authenticate using a PSP JWT"

  jwks_url = var.jwks_url
  bound_issuer = var.jwt_issuer
}

