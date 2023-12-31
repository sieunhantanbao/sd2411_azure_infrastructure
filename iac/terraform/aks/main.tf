# Create resource group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.locationk8s
    resource_group_name = var.resource_group_name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = var.admin_username

        ssh_key {
            key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_B2als_v2"
        os_disk_size_gb = 30
    }

    identity {
      type = "SystemAssigned"
    }
    
    # service_principal {
    #     client_id     = var.aks_service_principal_app_id
    #     client_secret = var.aks_service_principal_client_secret
    # }

    tags = {
        Environment = "Development"
    }
}