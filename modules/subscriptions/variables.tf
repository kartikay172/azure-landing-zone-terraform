variable "subscription_name" {
  type        = string
  description = "Subscription display name"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "management_group_id" {
  type        = string
  description = "Parent management group ID"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}