# Create a secret for accessing AWS Secrets Manager.
resource "kubernetes_secret" "secrets_manager_access_key" {
  metadata {
    name      = "secrets-manager-access-key"
    namespace = "external-secrets"
  }
  data = {
    "access-key-id"     = base64encode(var.secrets_manager_access_key_id)
    "secret-access-key" = base64encode(var.secrets_manager_secret_access_key)
  }
}
