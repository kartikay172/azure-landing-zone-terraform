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

variable "subnet_id" {
  type        = string
  description = "Subnet ID for AD Connect VM and Domain Services"
  default     = ""
}

variable "enable_ad_connect" {
  type        = bool
  description = "Enable Azure AD Connect VM (If Hybrid)"
  default     = false
}

variable "enable_domain_services" {
  type        = bool
  description = "Enable Azure AD Domain Services (If Required)"
  default     = false
}

variable "domain_name" {
  type        = string
  description = "Domain name for Azure AD DS"
  default     = "rahinfotech.local"
}

variable "ad_connect_admin_password" {
  type        = string
  description = "Admin password for AD Connect VM"
  default     = ""
  sensitive   = true
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}