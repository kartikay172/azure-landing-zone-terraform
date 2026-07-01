output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "Log Analytics Workspace ID"
}

output "log_analytics_workspace_name" {
  value       = azurerm_log_analytics_workspace.main.name
  description = "Log Analytics Workspace name"
}

output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "Key Vault ID"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "Key Vault URI"
}

output "recovery_vault_id" {
  value       = azurerm_recovery_services_vault.main.id
  description = "Recovery Services Vault ID"
}

output "automation_account_id" {
  value       = azurerm_automation_account.main.id
  description = "Automation Account ID"
}

output "storage_account_id" {
  value       = azurerm_storage_account.diagnostics.id
  description = "Diagnostics Storage Account ID"
}