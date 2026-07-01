# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_vnet_address_space
  tags                = var.common_tags
}

# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke_vnet_address_space
  tags                = var.common_tags
}

# Hub to Spoke Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke-${var.environment}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Spoke to Hub Peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub-${var.environment}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Route Table
resource "azurerm_route_table" "main" {
  name                = "rt-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  route {
    name           = "RouteToFirewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.4"
  }
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.${var.environment}.internal"
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Link DNS Zone to Hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "dns-link-hub-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
  tags                  = var.common_tags
}

# Link DNS Zone to Spoke VNet
resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  name                  = "dns-link-spoke-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
  registration_enabled  = false
  tags                  = var.common_tags
}