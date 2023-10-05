variable "resource_group_location" {
  default       = "southcentralus"
  description   = "Location of the resource group."
}

variable "agent_count" {
    default = 2
}

variable "dns_prefix" {
    default = "sd2411-my-todo-dns"
}

variable cluster_name {
    default = "sd2411_k8s_cluster"
}

variable resource_group_name {
    default = "sd2411_aks"
}

variable ssh_key_name {
  default = "mySSHKey"
}
variable locationk8s {
    default = "southcentralus"
}

variable aks_service_principal_app_id {
    default= "aks_service_principal_app_id"
}

variable aks_service_principal_client_secret{
    default = "aks_service_principal_client_secret"
}

variable aks_service_principal_object_id {
    default= "aks_service_principal_object_id"
}