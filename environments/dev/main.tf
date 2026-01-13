resource "azurerm_resource_group" "avd" {
  name     = "rg-avd-${var.environment}"
  location = var.location
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AVD-Capstone"
  }
}
# Testing PR workflow
