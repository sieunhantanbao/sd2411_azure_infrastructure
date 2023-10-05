output "vm_public_ip_address" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
}