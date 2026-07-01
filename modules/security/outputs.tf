output "sentinel_workspace_id" {
  value       = azurerm_log_analytics_workspace.sentinel.id
  description = "Sentinel Log Analytics Workspace ID"
}

output "firewall_policy_id" {
  value       = azurerm_firewall_policy.main.id
  description = "Azure Firewall Policy ID"
}

output "ddos_protection_plan_id" {
  value       = azurerm_network_ddos_protection_plan.main.id
  description = "DDoS Protection Plan ID"
}

output "purview_account_id" {
  value       = var.enable_purview ? azurerm_purview_account.main[0].id : null
  description = "Microsoft Purview Account ID"
}