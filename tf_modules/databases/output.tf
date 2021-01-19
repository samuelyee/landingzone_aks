output "endpoint" {
  value = azurerm_cosmosdb_account.mongodb.endpoint
  sensitive = true
}