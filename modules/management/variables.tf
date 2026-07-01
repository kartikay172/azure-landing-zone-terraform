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

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}