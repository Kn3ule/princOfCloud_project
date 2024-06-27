 # Set variables
 $RESOURCE_GROUP = "princOfCloud_project_rg"
 $STORAGE_ACCOUNT_NAME = "princofcloudprojectsa"
 $CONTAINER_NAME = "princofcloud-project-sc-file"
 $BLOB_NAME = "testfile.txt"
 $FILE = "testfile.txt"
 $APP_SERVICE_NAME = 'princOfCloud-project-lwa'
 $SOURCE_DIRECTORY = "web_app/my_web_app"
 $TARGET_DIRECTORY = "zip"
 $ZIP_FILE = "web_app.zip"
 $KEY_VAULT_NAME = "princOfCloud-project-kv"
 
 # Azure CLI Login (falls nicht bereits angemeldet)
 az login
 
 # Get back the storage account from which we are logged in 
 $sa = $(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT_NAME) | ConvertFrom-Json
 # Get the Storage account key
 $key = $sa[0].value
 
 # Store zip of web app in storage account
 # Upload the file to the blob container (override if existing)
 az storage blob upload --container-name $CONTAINER_NAME --file $FILE --name $BLOB_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $key --overwrite
 
 # Deploy the ZIP file to the Web App
 az webapp deploy --name $APP_SERVICE_NAME --resource-group $RESOURCE_GROUP --src-path "$TARGET_DIRECTORY/$ZIP_FILE" 
 