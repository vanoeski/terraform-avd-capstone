variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "storage_account_name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
    default = "eastus"
}

variable "account_tier" {
    type = string
    default = "Premium"
}

variable "account_replication_type" {
    type = string
    default = "LRS"
}

variable "access_tier" {
    type = string
    default = "Hot"
}

variable "share_name" {
    type = string
}

variable "storage_share_quota" {
    type = number
    default = 512
}

variable "private_endpoint_name" {
    type = string
}

variable "private_service_connection_name" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "account_kind" {
    type = string
    default = "FileStorage"
}

variable "private_dns_zone_id" {
    type = string
}