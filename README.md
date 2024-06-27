
# Azure Linux Web App Deployment mit Terraform (Principles of Cloud and DevOps Engineering)

Dieses Projekt beschreibt, wie man eine Azure Linux Web App mit einer systemzugewiesenen verwalteten Identität erstellt und die notwendigen Rollen und Berechtigungen für den Zugriff auf einen Azure Blob Storage und Azure Key Vault zuweist.

## Voraussetzungen

- Installierte [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Installiertes [Terraform](https://www.terraform.io/downloads.html)

## Schritte zur Ausführung

### 1. Bei der Azure CLI anmelden

Melde dich bei deinem Azure-Konto an:
```bash
az login
```

### 2. Ins Verzeichnis `terraform` wechseln

Wechsle in das Verzeichnis, das die Terraform-Dateien enthält:
```bash
cd terraform
```

### 3. `main.tfvars` Datei erstellen und anpassen

Erstelle eine `main.tfvars` Datei und setze die Werte TENANT_ID, SUBSCRIPTION_ID, OBJECT_ID entsprechend deiner Azure-Konfiguration:
```hcl
## SHARED
TF_VAR_TENANT_ID       = "<your-tenant-id>"
TF_VAR_SUBSCRIPTION_ID = "<your-subscription-id>"
TF_VAR_LOCATION        = "northeurope"
TF_VAR_OBJECT_ID       = "<your-object-id>" #verfügbar über folgenden CLI COMMAND: "az ad signed-in-user show" (id)


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
```

### 4. Terraform initialisieren, planen und anwenden

Initialisiere Terraform, erstelle den Plan und wende ihn an:
```bash
terraform init
terraform plan -var-file="main.tfvars"
terraform apply -var-file="main.tfvars"
```

### 5. Zurück zum Root-Verzeichnis wechseln

Wechsle zurück in das Root-Verzeichnis des Projekts:
```bash
cd ..
```

### 6. Shell-Skript ausführen, um die Web-App zu deployen

Führe das Shell-Skript aus, um die Web-App und den Speicher zu deployen:

Mac:
```bash
chmod +x deploy_webapp_with_storage.sh
./deploy_webapp_with_storage.sh
```

Windows:
```shell
.\deploy_webapp_with_storage.ps1
```

## Struktur des Projekts

```
root-directory/
├── terraform/
│   ├── main.tf
│   ├── storage.tf
│   ├── key_vault.tf
│   ├── app_service.tf
│   ├── variables.tf
│   ├── main.tfvars
│   └── ...
├── deploy_webapp_with_storage.sh
└── README.md
```

## Erklärung der Dateien

- **main.tf**: Hauptkonfigurationsdatei, die die Ressourcengruppe definiert.
- **variables.tf**: Datei zur Deklaration der Variablen.
- **main.tfvars**: Datei zur Bereitstellung der Variablenwerte.
- **deploy_webapp_with_storage.sh**: Shell-Skript zur Bereitstellung der Web-App und des Speichers. (MAC-Shell)