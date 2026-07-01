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

variable "enable_expressroute" {
  type        = bool
  description = "Enable ExpressRoute Gateway (If Required)"
  default     = false
}

variable "enable_route_server" {
  type        = bool
  description = "Enable Route Server (If Required)"
  default     = false
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}