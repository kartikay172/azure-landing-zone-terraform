terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "identity" {
  name     = "rg-\-identity"
  location = var.location
  tags     = local.common_tags
}

locals {
  common_tags = {
    Environment = var.environment
    Product     = "azure-landing-zone"
    ManagedBy   = "terraform"
  }
}

# Microsoft Entra ID / Azure AD - handled via Azure AD provider
# Privileged Identity Management
resource "azurerm_role_assignment" "pim_reader" {
  scope                = "/subscriptions/\"
  role_definition_name = "Reader"
  principal_id         = var.admin_principal_id
}
