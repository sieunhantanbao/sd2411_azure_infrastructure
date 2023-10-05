resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.locationk8s
    resource_group_name = var.resource_group_name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = var.ssh_public_key
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "standard_d2s_v3"
        os_disk_size_gb = 30
    }

    service_principal {
        client_id     = var.aks_service_principal_app_id
        client_secret = var.aks_service_principal_client_secret
    }

    tags = {
        Environment = "Development"
    }
}