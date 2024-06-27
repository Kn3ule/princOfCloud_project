# Create Storage Account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "sa" {
  name                     = var.TF_VAR_STORAGE_NAME
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.TF_VAR_STORAGE_ACCOUNT_TIER
  account_replication_type = var.TF_VAR_STORAGE_REPLICATION_TYPE

  tags = azurerm_resource_group.rg.tags
}

# Create Storage Container
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "sc" {
  name                  = var.TF_VAR_FILE_CONTAINER_NAME
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.TF_VAR_STORAGE_CONTAINER_ACCESS_TYPE
}

resource "azurerm_storage_container" "sc-tfstate" {
  name                  = var.TF_VAR_STATE_CONTAINER_NAME
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.TF_VAR_STORAGE_CONTAINER_ACCESS_TYPE
}




