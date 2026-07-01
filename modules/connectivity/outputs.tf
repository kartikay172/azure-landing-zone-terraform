output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Hub VNet ID"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hub.name
  description = "Hub VNet name"
}

output "firewall_private_ip" {
  value       = azurerm_firewall.main.ip_configuration[0].private_ip_address
  description = "Firewall private IP"
}

output "firewall_id" {
  value       = azurerm_firewall.main.id
  description = "Firewall ID"
}

output "ddos_protection_plan_id" {
  value       = azurerm_network_ddos_protection_plan.main.id
  description = "DDoS Protection Plan ID"
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.main.id
  description = "Private DNS Zone ID"
}

output "dns_resolver_id" {
  value       = azurerm_private_dns_resolver.main.id
  description = "Private DNS Resolver ID"
}

output "vpn_gateway_id" {
  value       = azurerm_virtual_network_gateway.vpn.id
  description = "VPN Gateway ID"
}

output "expressroute_gateway_id" {
  value       = var.enable_expressroute ? azurerm_virtual_network_gateway.expressroute[0].id : null
  description = "ExpressRoute Gateway ID"
}

output "route_server_id" {
  value       = var.enable_route_server ? azurerm_route_server.main[0].id : null
  description = "Route Server ID"
}