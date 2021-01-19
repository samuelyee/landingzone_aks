resource "azurerm_cosmosdb_account" "mongodb" {
  name                = "${var.prefix}-cosmosdb-mongo"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.prefix == "production" ? "Premium" : "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }

	tags     = var.tags
}

#store the connection string
resource "azurerm_key_vault_secret" "mongodb" {
  name         = "db-connection-string"
  value        = azurerm_cosmosdb_account.mongodb.connection_strings[0]
  key_vault_id = var.launchpad_kv_id
}

resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  for_each            = toset(var.mongo_db_names)
  name                = each.value
  resource_group_name = azurerm_cosmosdb_account.mongodb.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongodb.name
}