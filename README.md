# Setting Up the AKS Landing Zone
The original instruction will create random 5-char prefixes and suffixes for every resource name. It looks ugly and messy. Instead, let's create a static prefix without any suffixes.

1. Run `Remote-Container: Reopen in Container` in VSCode
1. Login to Azure and set the subscription
   ```
    rover login
    az account set -s <subcription name>
   ```

### Setting the Environment
```bash
export environment=STAGING
export random_length=0 # to disable random suffixes
export passthrough=false # set to false to enable prefix as below
export prefix=staging
```

### Clone the Foundation LZ
```
git clone --branch 2012.0.0 https://github.com/Azure/caf-terraform-landingzones.git /tf/caf/public
```

### Apply foundations (level 0 and 1)

```bash
# This is a specifically tailored version of the launchpad for this example and does not typically show all the launchpad features. Here it deploy the launchpad to store the tfstates, deploy log analytics, etc.
rover -lz /tf/caf/public/landingzones/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/examples/1-dependencies/launchpad/150 \
  -level level0 \
  -env ${environment} \
  -var random_length=${random_length} \
  -var passthrough=${passthrough} \
  -var prefix=${prefix} \
  -a [plan|apply|destroy]

# Level1
## To deploy AKS some dependencies, some accounting, security and governance services are required.
rover -lz /tf/caf/public/landingzones/caf_foundations \
  -level level1 \
  -env ${environment} \
  -a [plan|apply|destroy]

# Deploy shared_services typically monitoring, site recovery services, azure image gallery. In this example we dont deploy anything but it will expose the Terraform state to level 3 landing zones, so is required.
rover -lz /tf/caf/public/landingzones/caf_shared_services/ \
  -tfstate caf_shared_services.tfstate \
  -parallelism 30 \
  -level level2 \
  -env ${environment} \
  -a [plan|apply]
```

### Apply level 2 - network hub

The networking hub is part of the core enterprise landing zone services, you can deploy it with the following command:

```bash
rover -lz /tf/caf/public/landingzones/caf_networking/ \
  -tfstate networking_hub.tfstate \
  -var-folder /tf/caf/public/landingzones/caf_networking/scenario/100-single-region-hub \
  -env ${environment} \
  -level level2 \
  -a [plan|apply]
```

### Apply level 3 - network spoke

```bash
# Deploy networking spoke for AKS
rover -lz /tf/caf/public/landingzones/caf_networking/ \
  -tfstate networking_spoke_aks.tfstate \
  -var-folder /tf/caf/examples/1-dependencies/networking/spoke_aks/single_region \
  -env ${environment} \
  -level level3 \
  -a [plan|apply|destroy]

```
## Setup the AKS deployment

```bash
# Set the folder name of this example
example=101-single-cluster

rover -lz /tf/caf/ \
  -tfstate landingzone_aks.tfstate \
  -var-folder /tf/caf/examples/aks/${example} \
  -var tags={example=\"${example}\"} \
  -var prefix=${prefix} \
  -env ${environment} \
  -level level3 \
  -a [plan|apply]
```
### To destroy
```
example=101-single-cluster

rover -lz /tf/caf/ \
  -tfstate landingzone_aks.tfstate \
  -var-folder /tf/caf/examples/aks/${example} \
  -var tags={example=\"${example}\"} \
  -var prefix=${prefix} \
  -env ${environment} \
  -level level3 \
  -a destroy -auto-approve
```

### Install ingress-nginx and cert-manager in K8S
Refer to README under `examples\applications\ingress-nginx`

## Login to AKS
```
az aks get-credentials --resource-group staging-rg-aks-re1 --name staging-aks-akscluster-re1 --admin --overwrite
```
