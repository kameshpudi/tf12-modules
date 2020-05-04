resource "azurerm_subnet" "frontend_sn" {
  address_prefix            = var.frontend_sn_prefix
  name                      = "M-${upper(var.location)}-${upper(var.frontend_subnet_name)}"
  resource_group_name       = upper(var.vnet_resourcegroup_name)
  virtual_network_name      = upper(var.subscription_vnet_name)
}