variable "resource_group_name" {
  description = "Name of the resource group where networking resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region for all networking resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet (e.g., 10.0.0.0/16)"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create with their address prefixes"
  type = map(object({
    address_prefix = string
  }))
  default = {
    avd-hosts = {
      address_prefix = "10.0.1.0/24"
    }
    management = {
      address_prefix = "10.0.2.0/27"
    }
    AzureBastionSubnet = {
      address_prefix = "10.0.3.0/26"
    }
  }
}

variable "tags" {
  description = "Tags to apply to all networking resources"
  type        = map(string)
  default     = {}
}