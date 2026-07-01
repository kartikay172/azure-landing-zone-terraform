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

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
  default     = ""
}

variable "enable_purview" {
  type        = bool
  description = "Enable Microsoft Purview (If Required)"
  default     = false
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}