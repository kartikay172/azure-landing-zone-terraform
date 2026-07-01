terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    Environment = var.environment
    Product     = "azure-landing-zone"
    ManagedBy   = "terraform"
  }
}

resource "azurerm_resource_group" "connectivity" {
  name     = "rg-${var.environment}-connectivity"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.address_space
  tags                = local.common_tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/27"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_public_ip" "firewall" {
  name                = "pip-firewall-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_firewall" "main" {
  name                = "afw-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = local.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  tags                = local.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}