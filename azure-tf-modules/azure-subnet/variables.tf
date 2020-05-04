variable "location" {
  type    = string
}

variable "frontend_sn_prefix" {
  type    = string
  default = ""
}

variable "frontend_subnet_name"{
  type    = string
  description = "application specific subnet name"
  default = ""
}