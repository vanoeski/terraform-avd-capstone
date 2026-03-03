output "avd_subnet_id" {
    value = azurerm_subnet.subnet[var.avd_subnet_key].id
}

output "storage_subnet_id" {
    value = azurerm_subnet.subnet[var.storage_subnet_key].id
}

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "private_dns_zone_id" {
    value = azurerm_private_dns_zone.private_dns_zone.id
}