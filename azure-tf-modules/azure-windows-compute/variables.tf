variable "location" {
  type        = string
  description = "The azure location, either 'P2' or 'RK'"
}

variable "node_count" {
  type    = string
}

variable "extra_vm_tags" {
  type        = map(string)
  description = "Extra tags to be added to the base set"
  default     = {}
}
variable "license_type"{
default = "Windows_Server"
}

variable "disk_size_gb" {
  type    = string
  description = "OS Disk Size"
  default = "200"
}
variable "data_disk_size_gb" {
  type    = string
  description = "Data Disk Size"
}

variable "user" {
  type    = string
  description = "Local account user name"
  default = "00000001"
}
variable "user_password" {
  type        = string
  default     = ""
  description = "The initial password of the local admin account - changed after initial chef run to join the domain - access then only via CyberArk"
}

variable "size" {
  type = string
  description = "VM size type, feed from app repo at run time"
}

variable "managed_disk_type" {
  type    = string
  default = "Standard_LRS"
}
variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}
variable "image_offer" {
  type    = string
  default = "WindowsServer"
}
variable "image_sku" {
  type    = string
  default = "2016-Datacenter"
}
variable "image_version" {
  type    = string
  default = "latest"
}
variable "subnet_id" {
  type = string
  description = "application specific subnet id"
  default     =""
}
variable "resource_group_name" {
  type = string
  description = "application specific resource group"
  default     =""
}
variable "availability_set_id" {
  type        = string
  description = "Availability Set ID"
  default     = ""
}

variable "os_managed_disk_type" {
  type    = string
  default = "Standard_LRS"
}
variable "data_managed_disk_type" {
  type    = string
  default = "Standard_LRS"
}
