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

variable "address_space" {
  type        = list(string)
  description = "VNet address space"
  default     = ["10.0.0.0/16"]
}

variable "enable_aks" {
  type        = bool
  description = "Enable AKS cluster"
  default     = false
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}