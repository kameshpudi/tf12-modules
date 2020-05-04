output "public_ip" {
  value = azurerm_public_ip.win_pip.ip_address  
}

output "hostname" {
  value = azurerm_virtual_machine.main.name
}