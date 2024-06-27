#!/bin/bash

# Set variables
RESOURCE_GROUP="princOfCloud_project_rg"
STORAGE_ACCOUNT_NAME="princofcloudprojectsa"
CONTAINER_NAME="princofcloud-project-sc-file"
BLOB_NAME="testfile.txt"
FILE="testfile.txt"
APP_SERVICE_NAME='princOfCloud-project-lwa'
SOURCE_DIRECTORY="web_app/my_web_app"
TARGET_DIRECTORY="zip"
ZIP_FILE="web_app.zip"
KEY_VAULT_NAME="princOfCloud-project-kv"

#####################
# zip web app to store in storage account and deploy to azure
#####################
# Ensure target directory exists
mkdir -p $TARGET_DIRECTORY

# Change to the source directory
cd $SOURCE_DIRECTORY

# Zip the application files, excluding hidden files like .git, and save to target directory
#zip -r ../../$TARGET_DIRECTORY/$ZIP_FILE . -x '.??*'
# Create the zip file, excluding hidden files and the venv directory
zip -r ../../$TARGET_DIRECTORY/$ZIP_FILE . -x '.??*' -x 'venv/*'
# Change back to the original directory
cd -

# Azure CLI Login (falls nicht bereits angemeldet)
az login

# Get the Storage Account key
STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' --output tsv)

# Check if the Storage Account key was successfully retrieved
if [ -z "$STORAGE_ACCOUNT_KEY" ]; then
  echo "Fehler: Der Storage Account Schlüssel konnte nicht abgerufen werden."
  exit 1
fi

# store zip of web app in storage account
# Upload the file to the blob container (override if existing)
az storage blob upload --container-name $CONTAINER_NAME --file $FILE --name $BLOB_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $STORAGE_ACCOUNT_KEY --overwrite

# Deploy the ZIP file to the Web App
az webapp deploy --name $APP_SERVICE_NAME --resource-group $RESOURCE_GROUP --src-path $TARGET_DIRECTORY/$ZIP_FILE