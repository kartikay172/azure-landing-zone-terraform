# Subscription Management Group Association
resource "azurerm_management_group_subscription_association" "main" {
  management_group_id = var.management_group_id
  subscription_id     = "/subscriptions/${var.subscription_id}"
}