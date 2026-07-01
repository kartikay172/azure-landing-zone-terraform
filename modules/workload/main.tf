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

# AKS Subnet (If Required)
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

# App Service
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.environment}-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.common_tags

  site_config {
    always_on = false
  }
}

# Network Interface for VM
resource "azurerm_network_interface" "main" {
  count               = var.enable_vm ? 1 : 0
  name                = "nic-vm-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.virtual_machines.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  count               = var.enable_vm ? 1 : 0
  name                = "vm-${var.environment}-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  tags                = var.common_tags

  network_interface_ids = [azurerm_network_interface.main[0].id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Azure SQL Server (Database)
resource "azurerm_mssql_server" "main" {
  count                        = var.enable_database ? 1 : 0
  name                         = "sql-${var.environment}-workload"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.db_admin_password
  tags                         = var.common_tags
}

resource "azurerm_mssql_database" "main" {
  count     = var.enable_database ? 1 : 0
  name      = "db-${var.environment}"
  server_id = azurerm_mssql_server.main[0].id
  sku_name  = "Basic"
  tags      = var.common_tags
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

# AKS Cluster (If Required)
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