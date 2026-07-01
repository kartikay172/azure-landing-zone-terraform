variable "environment" {
  type        = string
  description = "Environment name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "admin_principal_id" {
  type        = string
  description = "Admin principal object ID"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}