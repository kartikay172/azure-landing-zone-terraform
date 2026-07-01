resource "azurerm_role_assignment" "entra_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = var.admin_principal_id
}

resource "azurerm_role_assignment" "pim_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = var.admin_principal_id
}

# Azure AD Connect - Sync on-premises AD to Entra ID
# Represented as a VM running AD Connect agent
resource "azurerm_network_interface" "ad_connect" {
  count               = var.enable_ad_connect ? 1 : 0
  name                = "nic-adconnect-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "ad_connect" {
  count               = var.enable_ad_connect ? 1 : 0
  name                = "vm-adconnect-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.ad_connect_admin_password
  tags                = var.common_tags

  network_interface_ids = [azurerm_network_interface.ad_connect[0].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# Domain Services (Azure AD DS)
resource "azurerm_active_directory_domain_service" "main" {
  count               = var.enable_domain_services ? 1 : 0
  name                = "aadds-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  domain_name         = var.domain_name
  sku                 = "Standard"
  tags                = var.common_tags

  initial_replica_set {
    subnet_id = var.subnet_id
  }

  notifications {
    notify_global_admins    = true
    notify_dc_admins        = true
  }
}

# Access Reviews - via role eligibility
resource "azurerm_role_assignment" "access_reviewer" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = var.admin_principal_id
}