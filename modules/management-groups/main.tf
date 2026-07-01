# Platform Management Group
resource "azurerm_management_group" "platform" {
  display_name               = "Platform Management Group"
  parent_management_group_id = var.root_management_group_id
}

# Landing Zone Management Group
resource "azurerm_management_group" "landing_zone" {
  display_name               = "Landing Zone Management Group"
  parent_management_group_id = var.root_management_group_id
}

# Non-Production Management Group
resource "azurerm_management_group" "non_production" {
  display_name               = "Non-Production Management Group"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}

# Production Management Group
resource "azurerm_management_group" "production" {
  display_name               = "Production Management Group"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}