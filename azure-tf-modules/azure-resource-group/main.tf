locals {
  resource_group          = "M-${upper(replace(var.location," ",""))}-RG"
}
resource "azurerm_resource_group" "group" {
  name                   = local.resource_group
  location               = var.location
}