output "sentinel_workspace_id" {
  value       = azurerm_log_analytics_workspace.sentinel.id
  description = "Sentinel Log Analytics Workspace ID"
}

output "firewall_policy_id" {
  value       = azurerm_firewall_policy.main.id
  description = "Azure Firewall Policy ID"
}