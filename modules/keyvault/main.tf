locals {
  common_tags = {
    environment = var.environment
    managedBy   = "Terraform"
    project     = var.project
  }
}



resource "azurerm_key_vault" "kv_avd_secrets" {
  name                       = "${var.project}-${var.environment}-kv"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  rbac_authorization_enabled = true
}

resource "azurerm_role_assignment" "avd_kv_secrets_officer" {
  role_definition_name = "Key Vault Secrets Officer"
  scope                = azurerm_key_vault.kv_avd_secrets.id
  principal_id         = var.principal_id
  principal_type       = "ServicePrincipal"
  description          = "Read and write secret contents including secret portion of a certificate with private key. Only works for key vaults that use the 'Azure role-based access control' permission model."
}

resource "time_sleep" "wait_for_rbac" {
  depends_on = [azurerm_role_assignment.avd_kv_secrets_user]
  create_duration = "90s"
  
}

resource "random_password" "avd_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "avd_admin_password" {
  depends_on = [ time_sleep.wait_for_rbac ]

  name         = "AVDAdminPassword"
  value        = random_password.avd_admin_password.result
  key_vault_id = azurerm_key_vault.kv_avd_secrets.id
}