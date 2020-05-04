variable "location" {
  type        = string
  description = "The azure location, either 'P2' or 'RK'"
}

variable "extra_vm_tags" {
  type        = map(string)
  description = "Extra tags to be added to the base set"
  default     = {}
}
variable "resource_group_name" {
  type = string
  description = "application specific resource group"
  default     =""
}