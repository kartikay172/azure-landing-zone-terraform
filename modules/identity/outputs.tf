output "subscription_scope" {
  value       = "/subscriptions/${var.subscription_id}"
  description = "Subscription scope"
}

output "ad_connect_vm_id" {
  value       = var.enable_ad_connect ? azurerm_windows_virtual_machine.ad_connect[0].id : null
  description = "AD Connect VM ID"
}

output "domain_service_id" {
  value       = var.enable_domain_services ? azurerm_active_directory_domain_service.main[0].id : null
  description = "Azure AD Domain Services ID"
}