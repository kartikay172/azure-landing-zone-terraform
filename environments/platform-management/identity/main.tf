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

resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.environment}-identity"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_role_assignment" "pim_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = var.admin_principal_id
}