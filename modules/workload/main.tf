# Spoke VNet
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.common_tags
}

# App Services Subnet
resource "azurerm_subnet" "app_services" {
  name                 = "snet-appservices-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 0)]
}

# Virtual Machines Subnet
resource "azurerm_subnet" "virtual_machines" {
  name                 = "snet-vms-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 1)]
}

# Databases Subnet
resource "azurerm_subnet" "databases" {
  name                 = "snet-databases-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 2)]
}

# AKS Subnet (if required)
resource "azurerm_subnet" "aks" {
  count                = var.enable_aks ? 1 : 0
  name                 = "snet-aks-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 4, 3)]
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.common_tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "st${replace(var.environment, "-", "")}wl"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.common_tags
}

# AKS Cluster (if required)
resource "azurerm_kubernetes_cluster" "main" {
  count               = var.enable_aks ? 1 : 0
  name                = "aks-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.environment}"
  tags                = var.common_tags

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks[0].id
  }

  identity {
    type = "SystemAssigned"
  }
}