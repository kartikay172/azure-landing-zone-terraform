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

locals {
  common_tags = {
    Environment = var.environment
    Product     = "azure-landing-zone"
    ManagedBy   = "terraform"
  }
}

resource "azurerm_resource_group" "workload" {
  name     = "rg-${var.environment}-workload"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  address_space       = var.address_space
  tags                = local.common_tags
}

resource "azurerm_subnet" "app_services" {
  name                 = "snet-appservices-${var.environment}"
  resource_group_name  = azurerm_resource_group.workload.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 0)]
}

resource "azurerm_subnet" "virtual_machines" {
  name                 = "snet-vms-${var.environment}"
  resource_group_name  = azurerm_resource_group.workload.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 1)]
}

resource "azurerm_subnet" "databases" {
  name                 = "snet-databases-${var.environment}"
  resource_group_name  = azurerm_resource_group.workload.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 2)]
}

resource "azurerm_storage_account" "main" {
  name                     = "st${replace(var.environment, "-", "")}lz"
  resource_group_name      = azurerm_resource_group.workload.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}

resource "azurerm_consumption_budget_subscription" "main" {
  name            = "budget-${var.environment}"
  subscription_id = "/subscriptions/${var.subscription_id}"
  amount          = var.budget_amount
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-07-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80.0
    operator       = "GreaterThan"
    contact_emails = [var.budget_notification_email]
  }
}