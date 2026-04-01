
variable "url" {
  description = "Base URL to the secrets manager"
  type        = string
}

variable "token" {
  description = "The token for the secrets manager. If set to the empty string, the Kubernetes Service Account is used for authentication instead."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "token_name" {
  description = "The name of the token that is used to make the Terraform changes. This name will be associated with all the changes that Terraform makes, so it's useful to set so it's possible to trace exactly what caused the changes."
  type        = string
}

variable "rabbitmq_username" {
  description = "The username for RabbitMQ"
  type        = string
  default     = "secrets-manager"
}

variable "auth_manager_bootstrap_admin_username" {
  description = "The username for the bootstrap admin account in the auth manager"
  type        = string
  default     = "bootstrap-admin"
}

variable "auth_manager_bootstrap_admin_password" {
  description = "The password for the bootstrap admin account in the auth manager. If set to the empty string, a password will be generated."
  type        = string
  default     = null
  sensitive   = true
  ephemeral   = true
}

variable "auth_manager_bootstrap_service_id" {
  description = "The client ID for the bootstrap service in the auth manager"
  type        = string
  default     = "tofu-runner"
}

variable "auth_manager_bootstrap_service_secret" {
  description = "The secret for the bootstrap service in the auth manager. If set to the empty string, a secret will be generated."
  type        = string
  default     = null
  sensitive   = true
  ephemeral   = true
}

variable "auth_manager_admin_app_secret" {
  description = "The secret for the admin app in the auth manager. If set to the empty string, a secret will be generated."
  type        = string
  default     = null
  sensitive   = true
  ephemeral   = true
}

variable "monitoring_admin_username" {
  description = "The username of the admin user in monitoring"
  type        = string
  default     = "admin"
}

variable "monitoring_admin_password" {
  description = "The password of the admin user in monitoring. If not set, a password will be generated."
  type        = string
  default     = null
  sensitive   = true
  ephemeral   = true
}

