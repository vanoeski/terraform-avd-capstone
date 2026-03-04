locals {
  common_tags = {
    environment = var.environment
    managedBy   = "Terraform"
    project     = var.project
  }
}

resource "azurerm_key_vault" "avd_secrets" {
  name                        = "${var.project}-${var.environment}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  rbac_authorization_enabled = true
}

resource "azurerm_role_assignment" "avd_kv_secrets_user" {
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.avd_secrets.id
  principal_id         = var.principal_id
  principal_type       = "ServicePrincipal"
  description          = "Read secret contents including secret portion of a certificate with private key. Only works for key vaults that use the 'Azure role-based access control' permission model."
}