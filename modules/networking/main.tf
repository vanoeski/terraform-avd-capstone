resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = var.resource_group_name
    address_space       = var.vnet_address_space
    location            = var.location
}

resource "azurerm_subnet" "subnet" {
    name                 = var.subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_nat_gateway" "nat_gateway" {
    name                = var.nat_gateway_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku_name            = "Standard"
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  subnet_id             = var.subnet_id
  nat_gateway_id        = azurerm_nat_gateway.nat_gateway.id
}