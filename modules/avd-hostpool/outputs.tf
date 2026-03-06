output "host_pool_id" {
  value = azurerm_virtual_desktop_host_pool.avd_hostpool.id
}

output "desktop_app_group_id" {
  value = azurerm_virtual_desktop_application_group.desktop_app_group.id
}

output "workspace_id" {
  value = azurerm_virtual_desktop_workspace.workspace.id
}