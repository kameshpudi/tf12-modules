# Configure the Azure Provider
provider "azurerm" {
  version         = ">= 2.0"
  features {}
  subscription_id = "7a35fc53-afbf-4a3b-b518-b14885b80740"
  client_id       = "7ddcb6ef-b397-44d2-a0a0-dfb1eb2b9087"
  client_secret   = data.terraform_remote_state.azure_subscription.outputs.clientsecret
  tenant_id       = "723aa938-17e0-4144-b82c-2903de9e1337"
}