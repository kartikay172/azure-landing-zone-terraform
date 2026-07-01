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

output "storage_account_id" {
  value       = azurerm_storage_account.main.id
  description = "Storage Account ID"
}

output "aks_cluster_id" {
  value       = var.enable_aks ? azurerm_kubernetes_cluster.main[0].id : null
  description = "AKS Cluster ID"
}