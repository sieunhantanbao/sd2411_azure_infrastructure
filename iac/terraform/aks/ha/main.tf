resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "control_plane" {
  name                = "control-plane-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "control_plane_subnet" {
  name                 = "control-plane-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.control_plane.name
  address_prefixes     = ["10.0.1.0/24"]
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

resource "azurerm_virtual_network_peering" "control_plane_to_worker" {
  name                         = "control-plane-to-worker"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.control_plane.name
  remote_virtual_network_id    = azurerm_virtual_network.worker_nodes.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "worker_to_control_plane" {
  name                         = "worker-to-control-plane"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.worker_nodes.name
  remote_virtual_network_id    = azurerm_virtual_network.control_plane.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_route_table" "control_plane_route_table" {
  name                = "control-plane-route-table"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_subnet_route_table_association" "control_plane_association" {
  subnet_id      = azurerm_subnet.control_plane_subnet.id
  route_table_id = azurerm_route_table.control_plane_route_table.id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "agentpool"
    node_count          = var.agent_count
    vm_size             = "Standard_B2als_v2" // Standard_DS2_v2
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2"]
    # enable_auto_scaling = true
    # min_count           = 1
    # max_count           = 2
    vnet_subnet_id      = azurerm_subnet.worker_nodes_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.0.0/16"
    pod_cidr       = "10.244.0.0/16"
    dns_service_ip = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    load_balancer_sku = "Standard"

    load_balancer_profile {
      outbound_ip_prefix_ids = []
    }
  }
#   service_principal {
#     client_id     = var.client_id
#     client_secret = var.client_secret
#   }
  tags = {
    Environment = var.tags
  }
}
