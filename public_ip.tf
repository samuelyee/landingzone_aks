module "caf_public_ip_addresses" {
  source  = "aztfmod/caf/azurerm//modules/networking/public_ip_addresses"
  version = "4.21.2"
  # insert the 9 required variables here
  allocation_method       = "Static"
  ip_version              = "IPv4"
  sku                     = "Standard"
  name                    = "${var.prefix}-cloudai-ingress"
  domain_name_label       = "${var.prefix}-cloudai-ingress"
  resource_group_name     = "${var.prefix}-rg-aks-nodes-re1"
  base_tags               = local.tags
  location                = local.location
  diagnostics             = local.diagnostics
}
