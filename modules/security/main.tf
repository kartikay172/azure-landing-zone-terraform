# Microsoft Defender for Cloud
resource "azurerm_security_center_subscription_pricing" "defender_vms" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "defender_sql" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "defender_keyvault" {
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_subscription_pricing" "defender_containers" {
  tier          = "Standard"
  resource_type = "Containers"
}

# Microsoft Sentinel
resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = "law-sentinel-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = var.common_tags
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "main" {
  workspace_id = azurerm_log_analytics_workspace.sentinel.id
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "main" {
  name                = "afwp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.common_tags

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "main" {
  name               = "DefaultRules"
  firewall_policy_id = azurerm_firewall_policy.main.id
  priority           = 100

  network_rule_collection {
    name     = "AllowAzureServices"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "AllowDNS"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }
  }
}

# DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "main" {
  name                = "ddos-security-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Microsoft Purview Account (If Required)
resource "azurerm_purview_account" "main" {
  count               = var.enable_purview ? 1 : 0
  name                = "purview-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.common_tags

  identity {
    type = "SystemAssigned"
  }
}