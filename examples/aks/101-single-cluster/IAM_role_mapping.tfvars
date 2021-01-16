azuread_groups = {
  aks_admins = {
    name        = "aks-admins"
    description = "Provide admin access to the AKS cluster."
    members = {
      user_principal_names = [
        "samuel-admin@projectinnovate.sg"
      ]
      # group_names = []
      # object_ids  = []
      # group_keys  = []

      # service_principal_keys = [
      # ]
    }
    prevent_duplicate_name = false
  }

  aks_contributors = {
    name        = "aks-contributors"
    description = "Provide contributor access to the AKS cluster."
    members = {
      user_principal_names = []
      group_names          = ["Cloud AI"]
      # object_ids  = []
      # group_keys  = []

      # service_principal_keys = [
      # ]
    }
    prevent_duplicate_name = false
  }

}

role_mapping = {
  custom_role_mapping = {}

  built_in_role_mapping = {
    aks_clusters = {
      cluster_re1 = {

        "Azure Kubernetes Service Cluster Admin Role" = {
          azuread_groups = {
            keys = ["aks_admins"]
          }
        }

        "Azure Kubernetes Service RBAC Admin" = {
          azuread_groups = {
            keys = ["aks_admins"]
          }
        }

        "Azure Kubernetes Service RBAC Writer" = {
          azuread_groups = {
            keys = ["aks_contributors"]
          }

        }

      }
    }

    azure_container_registries = {
      acr1 = {
        "AcrPull" = {
          aks_clusters = {
            keys = ["cluster_re1"]
          }
        }
      }
    }
  }
}