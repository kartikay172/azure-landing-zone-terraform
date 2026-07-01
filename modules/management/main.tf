# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.common_tags
}

# Azure Monitor Action Group
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "ag${var.environment}"
  tags                = var.common_tags
}

# Automation Account
resource "azurerm_automation_account" "main" {
  name                = "aa-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
  tags                = var.common_tags
}

# Link Automation to Log Analytics
resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  read_access_id      = azurerm_automation_account.main.id
}

# Update Manager - Maintenance Configuration
resource "azurerm_maintenance_configuration" "update_manager" {
  name                     = "mc-updates-${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = "User"
  tags                     = var.common_tags

  window {
    start_date_time = "2026-07-01 02:00"
    duration        = "02:00"
    time_zone       = "India Standard Time"
    recur_every     = "1Week"
  }

  install_patches {
    reboot = "IfRequired"

    windows {
      classifications_to_include = ["Critical", "Security", "UpdateRollup"]
    }

    linux {
      classifications_to_include = ["Critical", "Security"]
    }
  }
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  soft_delete_enabled = true
  tags                = var.common_tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.environment}-mgmt"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  tags                       = var.common_tags
}

# Storage Account (Diagnostics)
resource "azurerm_storage_account" "diagnostics" {
  name                     = "st${replace(var.environment, "-", "")}diag"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.common_tags
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${var.environment}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
  }
}