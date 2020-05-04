data "terraform_remote_state" "azure_subscription" {
  backend = "local"

  config = {
    path = "../subscription/terraform.tfstate"
  }
}

locals {
  resource_group          = "M-${upper(replace(var.location," ",""))}-RG"
}

# Create a resource group
resource "azurerm_resource_group" "group" {
  name     = local.resource_group
  location = var.location
}
