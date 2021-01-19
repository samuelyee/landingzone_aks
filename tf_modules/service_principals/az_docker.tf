## create service principal for ACR for docker pull & push
resource "azuread_application" "docker" {
  name                       = "${var.prefix}-docker-login"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "random_password" "docker" {
  length  = 32
  special = true
}

resource "azuread_application_password" "docker" {
  application_object_id = azuread_application.docker.id
  value                 = random_password.docker.result
  end_date              = "2040-01-01T01:02:03Z"
}

resource "azuread_service_principal" "docker" {
  application_id = azuread_application.docker.application_id
}

# store the docker url for keyvault
resource "azurerm_key_vault_secret" "docker_url" {
  name         = "docker-id"
  value        = "https://${var.az_docker_server}"
  key_vault_id = var.launchpad_kv_id
}

# store the docker id for keyvault
resource "azurerm_key_vault_secret" "docker_id" {
  name         = "docker-id"
  value        = azuread_service_principal.docker.application_id
  key_vault_id = var.launchpad_kv_id
}

# store the docker password for keyvault
resource "azurerm_key_vault_secret" "docker_password" {
  name         = "docker-password"
  value        = azuread_application_password.docker.value
  key_vault_id = var.launchpad_kv_id
}

# assign acr role to docker
resource "azurerm_role_assignment" "acr_push" {
  scope                = var.az_docker_id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.docker.object_id
}

# assign acr role to docker
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.az_docker_id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.docker.object_id
}



