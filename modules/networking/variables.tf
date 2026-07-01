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

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "Hub VNet address space"
  default     = ["10.0.0.0/16"]
}

variable "spoke_vnet_address_space" {
  type        = list(string)
  description = "Spoke VNet address space"
  default     = ["10.1.0.0/16"]
}

variable "hub_vnet_id" {
  type        = string
  description = "Hub VNet ID for peering"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}