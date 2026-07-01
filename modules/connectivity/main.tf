# Hub VNet
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.common_tags
}

# Azure Firewall Subnet
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 0)]
}

# Gateway Subnet (VPN + ExpressRoute)
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 3, 2)]
}

# Bastion Subnet
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 3, 3)]
}

# Route Server Subnet
resource "azurerm_subnet" "route_server" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 3, 4)]
}

# Private DNS Resolver Inbound Subnet
resource "azurerm_subnet" "dns_resolver_inbound" {
  name                 = "snet-dns-inbound-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 10)]

  delegation {
    name = "dns-resolver"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Firewall Public IP
resource "azurerm_public_ip" "firewall" {
  name                = "pip-firewall-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

# Azure Firewall
resource "azurerm_firewall" "main" {
  name                = "afw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = var.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Bastion Public IP
resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

# Azure Bastion
resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# VPN Gateway Public IP
resource "azurerm_public_ip" "vpn_gateway" {
  name                = "pip-vpngw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

# VPN Gateway
resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "vpngw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  tags                = var.common_tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}

# ExpressRoute Gateway (If Required)
resource "azurerm_public_ip" "expressroute" {
  count               = var.enable_expressroute ? 1 : 0
  name                = "pip-ergw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_virtual_network_gateway" "expressroute" {
  count               = var.enable_expressroute ? 1 : 0
  name                = "ergw-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "ExpressRoute"
  sku                 = "Standard"
  tags                = var.common_tags

  ip_configuration {
    name                          = "erGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.expressroute[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}

# Private DNS Resolver
resource "azurerm_private_dns_resolver" "main" {
  name                = "dnsresolver-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.hub.id
  tags                = var.common_tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  name                    = "dns-inbound-${var.environment}"
  private_dns_resolver_id = azurerm_private_dns_resolver.main.id
  location                = var.location
  tags                    = var.common_tags

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_resolver_inbound.id
  }
}

# DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "main" {
  name                = "ddos-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.${var.environment}.local"
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Private DNS Zone VNet Link
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "dns-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  tags                  = var.common_tags
}

# Route Server (If Required)
resource "azurerm_public_ip" "route_server" {
  count               = var.enable_route_server ? 1 : 0
  name                = "pip-routeserver-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_route_server" "main" {
  count                            = var.enable_route_server ? 1 : 0
  name                             = "routeserver-${var.environment}"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.route_server[0].id
  subnet_id                        = azurerm_subnet.route_server.id
  branch_to_branch_traffic_enabled = true
  tags                             = var.common_tags
}