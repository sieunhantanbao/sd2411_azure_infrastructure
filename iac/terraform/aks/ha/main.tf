resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "worker_nodes" {
  name                = "worker-nodes-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "worker_nodes_subnet" {
  name                 = "worker-nodes-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.worker_nodes.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "agentpool"
    node_count          = var.agent_count
    vm_size             = "Standard_B2s_v2"
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2"]
    vnet_subnet_id      = azurerm_subnet.worker_nodes_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    load_balancer_sku = "Standard"

    load_balancer_profile {
      outbound_ip_prefix_ids = []
    }
  }

  tags = {
    Environment = var.tags
  }
}
