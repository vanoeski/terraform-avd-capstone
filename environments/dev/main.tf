resource "random_string" "storage_suffix" {
  length      = 6
  upper       = false
  min_numeric = 1
  special     = false
}

resource "azurerm_resource_group" "avd" {
  name     = "rg-avd-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    managedBy   = "Terraform"
    project     = "AVD-Capstone"
  }
}

module "networking" {
  source = "../../modules/networking"

  subnets = {
    "storage" = {
      address_prefixes   = ["10.0.1.0/24"],
      attach_nat_gateway = false,
    name = "avd-poc-storage-snet" }
    "avd-hosts" = {
      address_prefixes   = ["10.0.2.0/24"],
      attach_nat_gateway = true,
    name = "avd-poc-avd-hosts-snet" }
  }

  environment         = "poc"
  project             = "avd-capstone"
  vnet_name           = "avd-poc-vnet"
  resource_group_name = azurerm_resource_group.avd.name
  vnet_address_space  = ["10.0.0.0/16"]
  avd_subnet_key      = "avd-hosts"
  storage_subnet_key  = "storage"
  nat_gateway_name    = "avd-poc-nat-gateway"

}

module "storage" {
  source = "../../modules/storage"

  environment                     = "poc"
  project                         = "avd-capstone"
  storage_account_name            = "stavdpoc${random_string.storage_suffix.result}"
  resource_group_name             = azurerm_resource_group.avd.name
  location                        = var.location
  access_tier                     = "Hot"
  account_kind                    = "FileStorage"
  account_tier                    = "Premium"
  account_replication_type        = "LRS"
  share_name                      = "avdpocshare"
  storage_share_quota             = 5120
  private_endpoint_name           = "avdpocstoragepe"
  private_service_connection_name = "avdpocstoragepsc"
  private_dns_zone_id             = module.networking.private_dns_zone_id
  subnet_id                       = module.networking.storage_subnet_id
}