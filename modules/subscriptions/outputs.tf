output "subscription_id" {
  value       = var.subscription_id
  description = "Subscription ID"
}

output "subscription_resource_id" {
  value       = "/subscriptions/${var.subscription_id}"
  description = "Full subscription resource ID"
}

output "management_group_id" {
  value       = var.management_group_id
  description = "Associated Management Group ID"
}