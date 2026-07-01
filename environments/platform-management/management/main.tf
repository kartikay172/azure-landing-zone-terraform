terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "local" { path = "terraform.tfstate" }
}

provider "azurerm" { features {} }

locals {
  common_tags = {
    Environment = var.environment
    Product     = "azure-landing-zone"
    ManagedBy   = "terraform"
  }
}

resource "azurerm_resource_group" "management" {
  name     = "rg-\-management"
  location = var.location
  tags     = local.common_tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-\"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

# Automation Account
resource "azurerm_automation_account" "main" {
  name                = "aa-\"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
  sku_name            = "Basic"
  tags                = local.common_tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                = "kv-\-mgmt"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
  tenant_id           = var.tenant_id
  sku_name            = "standard"
  tags                = local.common_tags
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-\"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "Standard"
  tags                = local.common_tags
}
