## SHARED
TF_VAR_TENANT_ID       = "<your-tenant-id>"
TF_VAR_SUBSCRIPTION_ID = "<your-subscription-id>"
TF_VAR_LOCATION        = "northeurope"
TF_VAR_OBJECT_ID       = "<your-object-id>"


## RESOURCE GROUP
TF_VAR_RESOURCE_GROUP_NAME = "princOfCloud_project_rg"


## KEY VAULT
TF_VAR_KEYVAULT_NAME = "princOfCloud-project-kv"
TF_VAR_SKU_NAME_KV = "standard"
TF_VAR_SA_KEY_NAME = "storage-account-key"
TF_VAR_FLASK_SECRET_KEY_NAME = "flask-secret-key"
TF_VAR_FLASK_SECRET_KEY_VALUE ="BeispielSecretKey"



## STORAGE ACCOUNT + CONTAINER
TF_VAR_STORAGE_NAME = "princofcloudprojectsa"
TF_VAR_STORAGE_ACCOUNT_TIER = "Standard"
TF_VAR_STORAGE_REPLICATION_TYPE = "LRS"
TF_VAR_FILE_CONTAINER_NAME = "princofcloud-project-sc-file"
TF_VAR_STATE_CONTAINER_NAME = "princofcloud-project-tfstate"
TF_VAR_STORAGE_CONTAINER_ACCESS_TYPE = "private"

## APP SERVICE
TF_VAR_SERVICE_PLAN_NAME = "princOfCloud-project-sp"
TF_VAR_SERVICE_PLAN_OS = "Linux"
TF_VAR_SERVICE_PLAN_SKU = "B1"
TF_VAR_WEB_APP_NAME = "princOfCloud-project-lwa"
TF_VAR_WEB_APP_HTTPS_ONLY = true
