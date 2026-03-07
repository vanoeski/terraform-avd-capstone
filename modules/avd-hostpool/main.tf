locals {
  common_tags = {
    environment = var.environment
    managedBy   = "Terraform"
    project     = var.project
  }
}

resource "azurerm_virtual_desktop_host_pool" "avd_hostpool" {
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  name               = var.host_pool_name
  friendly_name      = var.friendly_name
  description        = var.description
  type               = var.host_pool_type
  load_balancer_type = var.load_balancer_type
}

resource "azurerm_virtual_desktop_application_group" "desktop_app_group" {
  name                = var.app_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  type          = var.app_group_type
  host_pool_id  = azurerm_virtual_desktop_host_pool.avd_hostpool.id
  friendly_name = var.app_group_friendly_name
  description   = var.app_group_description
}

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  friendly_name = var.workspace_friendly_name
  description   = var.workspace_description
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace_app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.desktop_app_group.id
}

resource "azurerm_network_interface" "avd_nic" {
  for_each = toset(formatlist("%s", range(var.vm_count)))

  name                = "${var.host_pool_name}-nic${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags

  ip_configuration {
    name                          = "${var.host_pool_name}-nic${each.value}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  for_each = toset(formatlist("%s", range(var.vm_count)))

  name                = "${var.host_pool_name}-vm${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [azurerm_network_interface.avd_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-25h2-avd"
    version   = "latest"
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd_hostpool.id
  expiration_date = timeadd(timestamp(), "8h")
}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  for_each = toset(formatlist("%s", range(var.vm_count)))

  name                       = "${var.host_pool_name}-vm${each.value}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[each.key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02714.342.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.avd_hostpool.name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.registration_info.token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_desktop_host_pool.avd_hostpool
  ]
}