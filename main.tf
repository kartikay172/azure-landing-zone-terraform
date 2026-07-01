terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ── ROOT MANAGEMENT GROUP ──────────────────────────────────────
resource "azurerm_management_group" "root" {
  display_name = "Tenant Root Group"
}

# ── PLATFORM MANAGEMENT GROUP ──────────────────────────────────
resource "azurerm_management_group" "platform_management" {
  display_name               = "Platform Management Group"
  parent_management_group_id = azurerm_management_group.root.id
}

# ── LANDING ZONE MANAGEMENT GROUP ─────────────────────────────
resource "azurerm_management_group" "landing_zone" {
  display_name               = "Landing Zone Management Group"
  parent_management_group_id = azurerm_management_group.root.id
}

# ── NON-PRODUCTION MANAGEMENT GROUP ───────────────────────────
resource "azurerm_management_group" "non_production" {
  display_name               = "Non-Production Management Group"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}

# ── PRODUCTION MANAGEMENT GROUP ────────────────────────────────
resource "azurerm_management_group" "production" {
  display_name               = "Production Management Group"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}
