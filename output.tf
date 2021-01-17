output aks_clusters_kubeconfig {
  value = {
    for key, aks_cluster in module.caf.aks_clusters : key => {
      aks_kubeconfig_cmd       = aks_cluster.aks_kubeconfig_cmd
      aks_kubeconfig_admin_cmd = aks_cluster.aks_kubeconfig_admin_cmd
    }
  }
  sensitive = false
}

output resource_groups {
  value = {
    resource_groups = module.caf.resource_groups
    # tfstates = local.tfstates.launchpad["subscription_id"]
    # global_settings = local.global_settings
    # acr_rbac_id = var.azure_container_registries["acr1"]
  }
  sensitive = true # toogle to false for debugging
}

output aks_clusters {
  value     = map(var.landingzone.key, module.caf.aks_clusters)
  sensitive = true
}

output global_settings {
  value     = local.global_settings
  sensitive = false
}

output virtual_machines {
  value     = module.caf.virtual_machines
  sensitive = false
}

output ingress_nginx {
  value = {
    fqdn        = module.caf_public_ip_addresses.fqdn
    ip_address  = module.caf_public_ip_addresses.ip_address
  }
  sensitive = false
}
