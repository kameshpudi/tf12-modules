data "terraform_remote_state" "azure_subscription" {
  backend = "local"

  config = {
    path = "../subscription/terraform.tfstate"
  }
}

module "demo_resourcegroup"{
  source = "../azure-tf-modules/azure-resource-group"
  location = var.location
}

module "demo_win_vm"{
  source = "../azure-tf-modules/windows-compute"
  location = var.location
  resource_group_name = module.demo_resourcegroup.resource_group_name
}