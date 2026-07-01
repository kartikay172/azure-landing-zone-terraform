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