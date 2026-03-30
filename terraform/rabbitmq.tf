
ephemeral "random_password" "rabbitmq_seed" {
  length  = 24
  special = false
}

resource "vault_kv_secret_v2" "rabbitmq_seed_storage" {
  mount = local.mounts.kv.path
  name  = "rabbitmq/root-user-seed"

  data_json_wo = jsonencode({
    username = var.rabbitmq_username
    password = ephemeral.random_password.rabbitmq_seed.result
  })
  data_json_wo_version = 1
}

resource "vault_rabbitmq_secret_backend" "rabbitmq" {
  connection_uri = "http://rabbitmq.rabbit-mq.svc.cluster.local:15672"
  username       = var.rabbitmq_username

  password_wo         = ephemeral.random_password.rabbitmq_seed.result
  password_wo_version = 1

  depends_on = [vault_kv_secret_v2.rabbitmq_seed_storage]
}

# Credentials rotation
# resource "vault_generic_endpoint" "rotate_rabbitmq_root" {
#   path = "${vault_rabbitmq_secret_backend.rabbitmq.path}/config/root/rotate"
#   data_json = "{}"
#
#   disable_read   = true
#   disable_delete = true
#
#   lifecycle {
#     replace_triggered_by = [
#       vault_rabbitmq_secret_backend.rabbitmq.id
#     ]
#   }
# }
#
