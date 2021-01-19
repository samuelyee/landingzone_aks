# Grant development access to key vault
resource "azurerm_key_vault_access_policy" "kv_level3" {
  key_vault_id = var.launchpad_kv_id
  tenant_id    = var.tenant_id
  object_id    = var.developers

  secret_permissions = var.prefix == "production" ? [ "get" ] : [ "get", "list", "set", "delete", "purge" ]
}