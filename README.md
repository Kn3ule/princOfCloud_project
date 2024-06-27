
# Azure Linux Web App Deployment mit Terraform

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

### 3. `terraform.tfvars` Datei anpassen

Bearbeite die `terraform.tfvars` Datei und setze die folgenden Werte entsprechend deiner Azure-Konfiguration:
```hcl
tenant_id       = "<your-tenant-id>"
subscription_id = "<your-subscription-id>"
object_id       = "<your-object-id>"
```

### 4. Terraform initialisieren, planen und anwenden

Initialisiere Terraform, erstelle den Plan und wende ihn an:
```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 5. Zurück zum Root-Verzeichnis wechseln

Wechsle zurück in das Root-Verzeichnis des Projekts:
```bash
cd ..
```

### 6. Shell-Skript ausführen, um die Web-App zu deployen

Führe das Shell-Skript aus, um die Web-App und den Speicher zu deployen:
```bash
./deploy_webapp_with_storage.sh
```

## Struktur des Projekts

```
root-directory/
├── terraform/
│   ├── main.tf
│   ├── storage.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── main.tfvars
│   ├── outputs.tf
│   └── ...
├── deploy_webapp_with_storage.sh
└── README.md
```

## Erklärung der Dateien

- **main.tf**: Hauptkonfigurationsdatei, die die Ressourcen definiert.
- **variables.tf**: Datei zur Deklaration der Variablen.
- **terraform.tfvars**: Datei zur Bereitstellung der Variablenwerte.
- **outputs.tf**: Datei zur Deklaration der Outputs.
- **deploy_webapp_with_storage.sh**: Shell-Skript zur Bereitstellung der Web-App und des Speichers.

## Nützliche Befehle

### Azure CLI Befehle

- Anmeldung bei Azure:
```bash
az login
```

- Anzeigen der verfügbaren Subscriptions:
```bash
az account list --output table
```

- Setzen der Subscription:
```bash
az account set --subscription <subscription-id>
```

### Terraform Befehle

- Initialisieren des Terraform-Arbeitsverzeichnisses:
```bash
terraform init
```

- Erstellen eines Ausführungsplans:
```bash
terraform plan -var-file="terraform.tfvars"
```

- Anwenden des Ausführungsplans:
```bash
terraform apply -var-file="terraform.tfvars"
```

- Anzeigen des Zustands:
```bash
terraform show
```

- Löschen der bereitgestellten Ressourcen:
```bash
terraform destroy -var-file="terraform.tfvars"
```

## Hinweise

Stelle sicher, dass alle erforderlichen Werte in der `terraform.tfvars` Datei korrekt gesetzt sind, bevor du die Terraform-Befehle ausführst. Das Shell-Skript `deploy_webapp_with_storage.sh` sollte ebenfalls ausführbar gemacht werden, bevor es ausgeführt wird:
```bash
chmod +x deploy_webapp_with_storage.sh
```

## Unterstützung

Bei Fragen oder Problemen wende dich bitte an den Projektbetreuer.
