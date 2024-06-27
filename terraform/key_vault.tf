#Defining Key Vault to store keys
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault

resource "azurerm_key_vault" "kv" {
  name                        = var.TF_VAR_KEYVAULT_NAME
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = var.TF_VAR_SKU_NAME_KV

  # Set for the account the permissions on the secrets
  # object_id is hard coded in tfvars because of following issue:
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/2901
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.TF_VAR_OBJECT_ID

    # Set the permissions that we can create a secret
    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}


resource "azurerm_key_vault_secret" "sa_key" {
  name         = var.TF_VAR_SA_KEY_NAME
  value        = azurerm_storage_account.sa.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "flask_secretkey" {
  name         = var.TF_VAR_FLASK_SECRET_KEY_NAME
  value        = var.TF_VAR_FLASK_SECRET_KEY_VALUE
  key_vault_id = azurerm_key_vault.kv.id
}