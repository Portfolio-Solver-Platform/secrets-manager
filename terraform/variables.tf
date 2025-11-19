variable "environment" {
  type        = string
  description = "Deployment environment"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "url" {
  description = "Base URL to the secrets manager"
  type        = string
}

variable "token" {
  description = "The token for the secrets manager"
  type        = string
  sensitive   = true
}

variable "token_name" {
  description = "The name of the token that is used to make the Terraform changes. This name will be associated with all the changes that Terraform makes, so it's useful to set so it's possible to trace exactly what caused the channges. For example, in production, it could be set to the CI/CD execution job."
  type        = string
}

variable "jwt_issuer" {
  description = "The issuer of JWT tokens"
  type        = string
}

variable "jwks_url" {
  description = "The url to the jwks"
  type        = string
}
