output "ssh_public_key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}