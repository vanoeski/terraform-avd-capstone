variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
}

variable "host_pool_name" {
  type = string
}

variable "friendly_name" {
  type = string
}

variable "description" {
  type = string
}

variable "host_pool_type" {
  type    = string
  default = "Pooled"
}

variable "load_balancer_type" {
  type    = string
  default = "DepthFirst"
}

variable "app_group_name" {
  type = string
}

variable "app_group_type" {
  type    = string
  default = "Desktop"
}

variable "app_group_friendly_name" {
  type = string
}

variable "app_group_description" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "workspace_friendly_name" {
  type = string
}

variable "workspace_description" {
  type = string
}

variable "vm_count" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  # VM SKU
  type    = string
  default = "Standard_B2ls_v2"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
  sensitive = true
}