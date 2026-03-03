locals {
    common_tags = {
        environment = var.environment
        managedBy   = "Terraform"
        project     = var.project
    }
}

resource "azurerm_storage_account" "avd" {
    name                        = var.storage_account_name
    resource_group_name         = var.resource_group_name
    location                    = var.location
    access_tier                 = var.access_tier
    account_kind                = var.account_kind
    account_tier                = var.account_tier
    account_replication_type    = var.account_replication_type
    tags                        = local.common_tags
}

resource "azurerm_storage_share" "avd" {
    name                 = var.share_name
    storage_account_id   = azurerm_storage_account.avd.id
    quota                = var.storage_share_quota
}

resource "azurerm_private_endpoint" "avd_storage" {
    name = var.private_endpoint_name
    location = var.location
    resource_group_name = var.resource_group_name
    subnet_id = var.subnet_id
    private_service_connection {
      name = var.private_service_connection_name
      private_connection_resource_id = azurerm_storage_account.avd.id
      subresource_names = ["file"]
      is_manual_connection = false
    }

    private_dns_zone_group {
        name = "${var.private_endpoint_name}-dnszonegroup"
        private_dns_zone_ids = [var.private_dns_zone_id]
    }
}