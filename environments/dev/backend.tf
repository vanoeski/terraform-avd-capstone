terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod"
    storage_account_name = "stejanavdtfqjpgwx"
    container_name       = "tfstate-avd"
    key                  = "dev.terraform.tfstate"
  }
}