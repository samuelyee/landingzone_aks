# Grant developer access to key vault
developers = "1f3a0eea-27ca-4c34-9ee6-fbdc1de8de0e"
mongo_db_names = [ # only letters, numbers and hyphens.
    "movies-db"
  ]

landingzone = {
  backend_type        = "azurerm"
  level               = "level3"
  key                 = "cluster_aks"
  global_settings_key = "shared_services"
  tfstates = {
    shared_services = {
      level   = "lower"
      tfstate = "caf_shared_services.tfstate"
    }
    networking_spoke_aks = {
      tfstate = "networking_spoke_aks.tfstate"
    }
  }
}

resource_groups = {
  aks_re1 = {
    name   = "aks-re1"
    region = "region1"
  }

  cosmosdb_region1 = {
    name   = "cosmosdb"
    region = "region1"
  }

  app_insights = {
    name   = "app_insights"
    region = "region1"
  }
}
