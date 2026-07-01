variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = ""
}

variable "admin_principal_id" {
  description = "Object ID of admin user or group"
  type        = string
  default     = ""
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "budget_amount" {
  description = "Monthly budget in USD"
  type        = number
  default     = 100
}

variable "budget_notification_email" {
  description = "Email for budget alerts"
  type        = string
}
