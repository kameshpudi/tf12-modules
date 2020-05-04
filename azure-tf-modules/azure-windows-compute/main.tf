locals {
  resource_group          = var.resource_group_name  
}

// Use a random suffix in hostnames
resource "random_string" "hostname_suffix" {
  count = var.node_count
  length = "${15 - length(local.prefix)}"
  lower = false
  number = true
  special = false
  upper = true
  keepers = {
    name = local.resource_group
  }
}
resource "azurerm_public_ip" "win_pip" {
  count               = var.node_count
  name                = "${random_string.hostname_suffix.*.result[count.index]}-PIP"
  location            = var.location
  resource_group_name = local.resource_group
  public_ip_address_allocation = "static"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "azurerm_network_interface" "winni" {
  count               = var.node_count
  name                = "${random_string.hostname_suffix.*.result[count.index]}-NIC1"
  location            = var.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "${random_string.hostname_suffix.*.result[count.index]}-NIC1-IPCONF"    
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.win_pip.*.id[count.index]
  }

  lifecycle {
    ignore_changes = [
      name,
    ip_configuration
    ]
  }
}
resource "azurerm_network_interface" "winni_static" {
  count               = var.node_count
  name                = "${random_string.hostname_suffix.*.result[count.index]}-NIC1"
  location            = var.location
  resource_group_name = local.resource_group
  depends_on          = [azurerm_network_interface.winni]

  ip_configuration {
    name                          = "${random_string.hostname_suffix.*.result[count.index]}-NIC1-IPCONF"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "static"
    private_ip_address            = azurerm_network_interface.winni.*.private_ip_address[count.index]
  }

  lifecycle {
    ignore_changes = [
      name,
      ip_configuration
    ]
  }
}
# initialize a random Admin user password. will be reset by cyberark onboarding
resource "random_string" "admin_password" {
  length      = 16
  min_special = 1
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}
resource "azurerm_managed_disk" "datadisk" {
  count                         = var.node_count
  name                          = "${random_string.hostname_suffix.*.result[count.index]}-DATADISK"
  location                      = var.location
  resource_group_name           = local.resource_group
  storage_account_type          = var.data_managed_disk_type
  create_option                 = "Empty"
  disk_size_gb                  = var.data_disk_size_gb
}
resource "azurerm_virtual_machine" "winvm" {
    count                         = var.node_count 
    name                          = "${random_string.hostname_suffix.*.result[count.index]}"
    location                      = var.location
    resource_group_name           = local.resource_group
    network_interface_ids         = [azurerm_network_interface.winni.*.id[count.index]]
    vm_size                       = var.size
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true
    license_type                  = var.license_type
    availability_set_id           = var.availability_set_id
    depends_on          = [azurerm_network_interface.winni_static]
    storage_image_reference {
        publisher = var.image_publisher
        offer     = var.image_offer
        sku       = var.image_sku
        version   = var.image_version
    }

    storage_os_disk {
        name                = "${random_string.hostname_suffix.*.result[count.index]}-OSDISK"
        managed_disk_type   = var.os_managed_disk_type
        disk_size_gb        = var.disk_size_gb
        caching             = "ReadWrite"
        create_option       = "FromImage"
    }
    # Data disk
    storage_data_disk {
        name                = "${random_string.hostname_suffix.*.result[count.index]}-DATADISK"
        managed_disk_type   = var.data_managed_disk_type
        caching             = "ReadWrite"
        create_option       = "Attach"
        disk_size_gb        = var.data_disk_size_gb
        managed_disk_id     = azurerm_managed_disk.datadisk.*.id[count.index]
        lun                 = 0
    }
    os_profile {
        computer_name  = "${random_string.hostname_suffix.*.result[count.index]}"
        admin_username = var.user
        # if the module was called with a password, use it, otherwise set to randomized string
        admin_password = var.user_password != "" ? var.user_password : random_string.admin_password.result
        # custom_data    = data.template_file.chef.rendered
    }
    os_profile_windows_config {
        provision_vm_agent  = true
    }
    boot_diagnostics {
        enabled     = "false"
    }

    tags = var.extra_vm_tags
}


/*resource "azurerm_virtual_machine_extension" "winextension" {
    count                = "${var.is_bootstrap ? var.count : 0}"
    name                 = "${random_string.hostname_suffix.*.result[count.index]}-bootstrap"
    location             = var.location
    resource_group_name  = local.resource_group
    virtual_machine_name = "${azurerm_virtual_machine.winvm.*.name[count.index]}"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.8"
    protected_settings = <<SETTINGS
    {
        "commandToExecute": "Powershell.exe -ExecutionPolicy Unrestricted ; "
    }
    SETTINGS
    lifecycle {
        ignore_changes = ["name","protected_settings"]
}
}*/