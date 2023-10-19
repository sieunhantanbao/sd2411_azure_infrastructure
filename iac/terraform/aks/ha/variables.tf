variable resource_group_name {
    default = "rg_sd2411_aks_ha"
}

variable resource_group_location {
  default       = "southeastasia"
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

# variable "client_id" {
#   description = "Azure AD Service Principal Client ID"
# }

# variable "client_secret" {
#   description = "Azure AD Service Principal Client Secret"
# }