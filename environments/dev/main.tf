resource "azurerm_resource_group" "avd" {
  name     = "rg-avd-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AVD-Capstone"
  }
}

module "networking" {
    source = "../../modules/networking"

    subnets = {
      "storage"     = { 
        address_prefixes = ["10.0.1.0/24"],
        attach_nat_gateway = false, 
        name = "avd-poc-storage-snet"}
      "avd-hosts" = { 
        address_prefixes = ["10.0.2.0/24"],
        attach_nat_gateway = true,
        name = "avd-poc-avd-hosts-snet"}
    }

    Environment = "poc"
    Project = "avd-capstone"
    vnet_name = "avd-poc-vnet"
    resource_group_name = azurerm_resource_group.avd.name
    vnet_address_space = ["10.0.0.0/16"]
    avd_subnet_key = "avd-hosts"
    storage_subnet_key = "storage"
    nat_gateway_name = "avd-poc-nat-gateway"

}