resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

locals {
  mounts = {
    kv = vault_mount.kv
  }
}

resource "vault_kv_secret_backend_v2" "example" {
  mount                = local.mounts.kv.path
  # max_versions         = 5
  # delete_version_after = 12600
  # cas_required         = true
}

resource "vault_kv_secret_v2" "artifact-write-creds" {
  mount                      = local.mounts.kv.path
  name                       = "artifact-write-creds"
  data_json_wo                  = jsonencode(
    {
      robot_name = "test-robot-name"
      secret = "test-robot-secret"
    }
  )
  data_json_wo_version = 1
}
