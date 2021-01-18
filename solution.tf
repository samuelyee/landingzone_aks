
module "caf" {
  # source = "git::https://github.com/aztfmod/terraform-azurerm-caf.git?ref=HN-aks-addons"
  source  = "aztfmod/caf/azurerm"
  version = "~> 0.4"

  current_landingzone_key  = var.landingzone.key
  tfstates                 = local.tfstates
  tags                     = local.tags
  global_settings          = local.global_settings
  diagnostics              = local.diagnostics
  logged_user_objectId     = var.logged_user_objectId
  logged_aad_app_objectId  = var.logged_aad_app_objectId
  resource_groups          = var.resource_groups
  storage_accounts         = var.storage_accounts
  azuread_groups           = var.azuread_groups
  keyvaults                = var.keyvaults
  keyvault_access_policies = var.keyvault_access_policies
  managed_identities       = var.managed_identities
  role_mapping             = var.role_mapping
  tenant_id                = var.tenant_id
  compute = {
    virtual_machines           = var.virtual_machines
    bastion_hosts              = var.bastion_hosts
    aks_clusters               = var.aks_clusters
    azure_container_registries = var.azure_container_registries
  }
  remote_objects = {
    vnets = local.remote.vnets
  }
}

locals {
  subscription_id = local.tfstates.cluster_aks["subscription_id"]
  launchpad_rg    = local.tfstates.cluster_aks["resource_group_name"]
}

# create service principal for Azure Pipeline
module "az_pipeline_sp" {
  source = "./modules/az_pipeline"

  prefix          = var.prefix
  aks_rg_scope    = module.caf.resource_groups["aks_re1"]["rbac_id"]
  subscription_id = local.subscription_id
  launchpad_rg    = local.launchpad_rg
  launchpad_kv_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.launchpad_rg}/providers/Microsoft.KeyVault/vaults/${var.prefix}-kv-level3"

}

module "database" {
  source = "./modules/database"

  prefix   = var.prefix
  tags     = local.tags
  location = local.location
  # resource group name defined in configuration.tfvars
  resource_group_name = "${var.prefix}-rg-${var.resource_groups.cosmosdb_region1.name}"
  launchpad_kv_id     = "/subscriptions/${local.subscription_id}/resourceGroups/${local.launchpad_rg}/providers/Microsoft.KeyVault/vaults/${var.prefix}-kv-level3"
}

