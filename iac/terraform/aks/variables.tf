variable resource_group_location {
  default       = "westcentralus"
  description   = "Location of the resource group."
}

variable agent_count {
    default = 2
}

variable dns_prefix {
    default = "sd2411-my-todo-dns"
}

variable cluster_name {
    default = "sd2411_k8s_cluster"
}

variable resource_group_name {
    default = "rg_sd2411_aks"
}

variable admin_username {
  default = "ubuntu"
  description = "The username to login to the VM"
}

variable ssh_key_name {
  default = "mySSHKey"
}
variable locationk8s {
    default = "westcentralus"
}