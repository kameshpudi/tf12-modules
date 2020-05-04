resource "azurerm_virtual_network" "example" {
  name                = "M-${upper(var.location)}-${upper(var.frontend_subnet_name)}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}