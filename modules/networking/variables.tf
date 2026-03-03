variable "vnet_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "nat_gateway_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Standard"
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "subnets" {
  type = map(object({
    name               = string
    address_prefixes   = list(string)
    attach_nat_gateway = bool
  }))
}

variable "avd_subnet_key" {
  type = string
}

variable "storage_subnet_key" {
  type = string
}

