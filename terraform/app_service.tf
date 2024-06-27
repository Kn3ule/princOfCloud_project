# Define App Service plan and App Service for fast API Application

# Define App Service plan for Linux Web App
# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan
resource "azurerm_service_plan" "sp" {
  name                = var.TF_VAR_SERVICE_PLAN_NAME
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = var.TF_VAR_SERVICE_PLAN_OS
  sku_name            = var.TF_VAR_SERVICE_PLAN_SKU
}


resource "azurerm_linux_web_app" "lwa" {
  name                = var.TF_VAR_WEB_APP_NAME
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id
  https_only            = var.TF_VAR_WEB_APP_HTTPS_ONLY


  identity {
    type = "SystemAssigned"
  }

  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      python_version = "3.9"
    }
  }
  # Set a connected storage account
  storage_account {
    access_key = azurerm_storage_account.sa.primary_access_key
    account_name = azurerm_storage_account.sa.name
    name = azurerm_storage_account.sa.name
    share_name = azurerm_storage_container.sc.name
    type = "AzureBlob"
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "true"
    "KEY_VAULT_URL"                       = azurerm_key_vault.kv.vault_uri
    "AZURE_STORAGE_CONTAINER_NAME"        = azurerm_storage_container.sc.name
    "AZURE_STORAGE_ACCOUNT_URL"           = "https://${azurerm_storage_account.sa.name}.blob.core.windows.net"
  }
}

data "azurerm_linux_web_app" "lwa_data"{
  name = azurerm_linux_web_app.lwa.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Set role assignement for access to blob storage
resource "azurerm_role_assignment" "blob_storage_access" {
  principal_id   = data.azurerm_linux_web_app.lwa_data.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope          = azurerm_storage_account.sa.id
}

# Set access policiy to get access to key vault secrets
resource "azurerm_key_vault_access_policy" "key_vault_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_linux_web_app.lwa_data.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

