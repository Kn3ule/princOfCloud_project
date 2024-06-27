##########################
## SECTION - PROVIDER INFO  
##########################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  subscription_id = var.TF_VAR_SUBSCRIPTION_ID
  features {}
}

#######################
## SECTION - COMPONENTS  
#######################

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.TF_VAR_RESOURCE_GROUP_NAME
  location = var.TF_VAR_LOCATION

  tags = {
    "env" = "project"
    "creator" = "tk"
    "source" = "terraform"
  }
}