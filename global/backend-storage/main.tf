resource "azurerm_resource_group" "tfstate" {
  name     = "rg-terraform-state"
  location = "eastus"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "sttfstatelz001"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

