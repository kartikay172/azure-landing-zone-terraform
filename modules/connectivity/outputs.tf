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