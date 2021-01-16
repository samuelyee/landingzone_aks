landingzone = {
  backend_type        = "azurerm"
  level               = "level4"
  key                 = "ingress-nginx"
  global_settings_key = "cluster_aks" # Update accordingly based on the configuration file of your AKS cluster landingzone.key
  tfstates = {
    cluster_aks = {
      level   = "lower"                   # Update accordingly based on the configuration file of your AKS cluster landingzone.key
      tfstate = "landingzone_aks.tfstate" # Update accordingly based on the value you used to deploy you aks cluster with the rover -tfstate <value>
    }
  }
}

cluster_re1_key = "cluster_re1"
# cluster_re2_key = "cluster_re2"


namespaces = {
  ingress-nginx = {
    name = "ingress-nginx"
    annotations = {
      name = "ingress-nginx-annotation"
    }
    labels = {
      mylabel = "ingress-nginx-value"
    }
  }

  cert-manager = {
    name = "cert-manager"
    annotations = {
      name = "cert-manager-annotation"
    }
    labels = {
      mylabel = "cert-manager-value"
    }
  }
}

helm_charts = {
  ingress-nginx = {
    name       = "ingress-nginx"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart      = "ingress-nginx"
    namespace  = "ingress-nginx"
  }

  cert-manager = {
    name       = "cert-manager"
    chart      = "cert-manager"
    repository = "https://charts.jetstack.io"
    namespace  = "cert-manager"
    sets = {
      "installCRDs" = true 
    }
    
  }
}