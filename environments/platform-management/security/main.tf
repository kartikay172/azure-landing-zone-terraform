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

resource "azurerm_resource_group" "security" {
  name     = "rg-${var.environment}-security"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_security_center_subscription_pricing" "defender" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = "law-sentinel-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.security.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.common_tags
}
