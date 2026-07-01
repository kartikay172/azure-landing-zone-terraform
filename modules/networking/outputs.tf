output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Hub VNet ID"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hub.name
  description = "Hub VNet name"
}

output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Spoke VNet ID"
}

output "spoke_vnet_name" {
  value       = azurerm_virtual_network.spoke.name
  description = "Spoke VNet name"
}

output "nsg_id" {
  value       = azurerm_network_security_group.main.id
  description = "Network Security Group ID"
}

output "route_table_id" {
  value       = azurerm_route_table.main.id
  description = "Route Table ID"
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.main.id
  description = "Private DNS Zone ID"
}