variable "resource_group_location" {
  default       = "southcentralus"
  description   = "Location of the resource group."
}

variable resource_group_name {
    default = "sd2411_vm"
}

variable "computer_name" {
  default = "hostname"
  description = "Computer name"
}

variable "admin_username" {
  default = "ubuntu"
  description = "The username to login to the VM"
}

variable "admin_password" {
  default = "Ubuntu123!@#"
  description = "The password to login to the VM"
}