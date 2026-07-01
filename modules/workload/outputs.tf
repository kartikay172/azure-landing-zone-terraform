output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Spoke VNet ID"
}

output "spoke_vnet_name" {
  value       = azurerm_virtual_network.spoke.name
  description = "Spoke VNet name"
}

output "app_service_plan_id" {
  value       = azurerm_service_plan.main.id
  description = "App Service Plan ID"
}

output "app_service_url" {
  value       = azurerm_linux_web_app.main.default_hostname
  description = "App Service URL"
}

output "storage_account_id" {
  value       = azurerm_storage_account.main.id
  description = "Storage Account ID"
}

output "vm_id" {
  value       = var.enable_vm ? azurerm_linux_virtual_machine.main[0].id : null
  description = "Virtual Machine ID"
}

output "sql_server_id" {
  value       = var.enable_database ? azurerm_mssql_server.main[0].id : null
  description = "SQL Server ID"
}

output "aks_cluster_id" {
  value       = var.enable_aks ? azurerm_kubernetes_cluster.main[0].id : null
  description = "AKS Cluster ID"
}