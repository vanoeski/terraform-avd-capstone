locals {
    common_tags = {
        environment = var.environment
        managedBy   = "Terraform"
        project     = var.project
    }
}

resource "azurerm_virtual_network" "vnet" {
    
    name                = var.vnet_name
    resource_group_name = var.resource_group_name
    address_space       = var.vnet_address_space
    location            = var.location
    tags                = local.common_tags
}

resource "azurerm_subnet" "subnet" {
    for_each = var.subnets

    name                 = each.value.name
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
    name                = "${var.vnet_name}-nsg"
    resource_group_name = var.resource_group_name
    location            = var.location
    tags                = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
    for_each = var.subnets

    subnet_id                 = azurerm_subnet.subnet[each.key].id
    network_security_group_id = azurerm_network_security_group.nsg.id

}

resource "azurerm_nat_gateway" "nat_gateway" {
    name                = var.nat_gateway_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku_name            = var.sku_name
    tags                = local.common_tags
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
    for_each = {
            for k,v in var.subnets : k => v
            if v.attach_nat_gateway == true
        }

    subnet_id             = azurerm_subnet.subnet[each.key].id
    nat_gateway_id        = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_public_ip" "nat_gateway_public_ip" {

    name                = "${var.nat_gateway_name}-pip"
    resource_group_name = var.resource_group_name
    location            = var.location
    allocation_method   = "Static"
    sku                 = "Standard"
    tags                = local.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  nat_gateway_id        = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id  = azurerm_public_ip.nat_gateway_public_ip.id
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
    name                = "privatelink.file.core.windows.net"
    resource_group_name = var.resource_group_name
    tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_storage_link" {
    name                  = "${var.vnet_name}-dns-link"
    resource_group_name   = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
    virtual_network_id    = azurerm_virtual_network.vnet.id
    registration_enabled  = false
}