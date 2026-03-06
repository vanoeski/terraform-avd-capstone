variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "location" {
  type = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "principal_id" {
  type = string
}