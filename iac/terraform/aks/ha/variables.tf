variable resource_group_name {
    default = "rg_sd2411_aks_ha"
}

variable resource_group_location {
  default       = "japaneast"
  description   = "Location of the resource group."
}

variable agent_count {
    default = 2
}

variable dns_prefix {
    default = "sd2411-my-todo-dns-ha"
}

variable cluster_name {
    default = "sd2411_k8s_cluster_ha"
}

variable "tags" {
  default = "Development"
}
