output "storage_account_id" {
  value = azurerm_storage_account.avd.id
}

output "storage_share_name" {
  value = azurerm_storage_share.avd.name
}