output "platform_mg_id" {
  value       = azurerm_management_group.platform.id
  description = "Platform Management Group ID"
}

output "landing_zone_mg_id" {
  value       = azurerm_management_group.landing_zone.id
  description = "Landing Zone Management Group ID"
}

output "non_production_mg_id" {
  value       = azurerm_management_group.non_production.id
  description = "Non-Production Management Group ID"
}

output "production_mg_id" {
  value       = azurerm_management_group.production.id
  description = "Production Management Group ID"
}