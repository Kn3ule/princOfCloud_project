######################
## SECTION - VARIABLES  
######################

#####################
## GLOBAL VARIABLES
#####################
variable "TF_VAR_TENANT_ID" {
  type        = string
  description = "id of the tenant to use."
}

variable "TF_VAR_SUBSCRIPTION_ID" {
  type        = string
  description = "id of the subscription to use."
}

variable "TF_VAR_LOCATION" {
  type        = string
  description = "Location of all resources."
}

variable "TF_VAR_OBJECT_ID" {
  type        = string
  description = "Object Id of User."
}


#####################
## RESOURCE GROUP VARIABLES
#####################
variable "TF_VAR_RESOURCE_GROUP_NAME" {
  type        = string
  description = "Name of the resource group."
}


#####################
## KEY VAULT VARIABLES
#####################
variable "TF_VAR_KEYVAULT_NAME" {
  type        = string
  description = "Name of the key vault."
}

variable "TF_VAR_SKU_NAME_KV" {
    type        = string
    description = "sku name of the key vault."
}

variable "TF_VAR_SA_KEY_NAME" {
    type        = string
    description = "name of the storage account secret."
}

variable "TF_VAR_FLASK_SECRET_KEY_NAME" {
    type        = string
    description = "name of the flask secret."
}

variable "TF_VAR_FLASK_SECRET_KEY_VALUE" {
    type        = string
    description = "value of the flask secret."
}


#####################
## STORAGE VARIABLES
#####################
## Variables for the Storage Account

variable "TF_VAR_STORAGE_NAME" {
    type = string
    description = "The name of the storage account"
}

variable "TF_VAR_STORAGE_ACCOUNT_TIER" {
  type = string
  description = "The tier of the storage account"
}

variable "TF_VAR_STORAGE_REPLICATION_TYPE" {
  type = string
  description = "The replication type of the storage account"
}

# Variables for storage container
variable "TF_VAR_FILE_CONTAINER_NAME"{
    type = string
    description = "The name of the storage container for files"
}

variable "TF_VAR_STATE_CONTAINER_NAME"{
    type = string
    description = "The name of the storage container for tfstate"
}

variable "TF_VAR_STORAGE_CONTAINER_ACCESS_TYPE"{
  type = string
  description = "The access type of the storage container"
}


#####################
## APP SERVICE
#####################

# App Service Plan name
variable "TF_VAR_SERVICE_PLAN_NAME"{
  type = string
  description = "The name of the app service plan for the linux application"
}

# App Service Plan os_type
variable "TF_VAR_SERVICE_PLAN_OS"{
  type = string
  description = "The operating system for the app service"
}

# App Service Plan sku
variable "TF_VAR_SERVICE_PLAN_SKU"{
  type = string
  description = "The sku name of the app service"
}

# Linux Web App name
variable "TF_VAR_WEB_APP_NAME"{
  type = string
  description = "The name of the linux web app"
}

# Linux Web App http status
variable "TF_VAR_WEB_APP_HTTPS_ONLY"{
  type = string
  description = "http status of the linux web app"
}

