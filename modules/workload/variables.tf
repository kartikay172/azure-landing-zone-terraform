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

variable "enable_vm" {
  type        = bool
  description = "Enable Virtual Machines"
  default     = false
}

variable "enable_database" {
  type        = bool
  description = "Enable Azure SQL Database"
  default     = false
}

variable "enable_aks" {
  type        = bool
  description = "Enable AKS cluster (If Required)"
  default     = false
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for Linux VMs"
  default     = ""
}

variable "db_admin_password" {
  type        = string
  description = "Database admin password"
  default     = ""
  sensitive   = true
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}