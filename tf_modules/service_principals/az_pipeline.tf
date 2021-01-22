## create service principal
resource "azuread_application" "azure_pipeline" {
  name                       = "${var.prefix}-azure-pipeline"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_service_principal" "azure_pipeline" {
  application_id = azuread_application.azure_pipeline.application_id

}

resource "random_password" "azure_pipeline" {
  length  = 32
  special = true
}

resource "azuread_application_password" "azure_pipeline" {
  application_object_id = azuread_application.azure_pipeline.id
  value                 = random_password.azure_pipeline.result
  end_date              = "2040-01-01T01:02:03Z"
}

# store the sp id for keyvault
resource "azurerm_key_vault_secret" "azure_pipeline_app_id" {
  name         = "azure-pipeline-app-id"
  value        = azuread_service_principal.azure_pipeline.application_id
  key_vault_id = var.launchpad_kv_id
}

# store the sp password for keyvault
resource "azurerm_key_vault_secret" "azure_pipeline_password" {
  name         = "azure-pipeline-password"
  value        = azuread_application_password.azure_pipeline.value
  key_vault_id = var.launchpad_kv_id
}

# create role assignments:
resource "azurerm_role_assignment" "azure_pipeline" {
  scope                = var.aks_rg_scope
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.azure_pipeline.object_id
}

# grant AKS role
resource "azuread_group_member" "azure_pipeline" {
  group_object_id   = var.aks_contributors
  member_object_id  = azuread_service_principal.azure_pipeline.object_id
}
