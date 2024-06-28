
# Azure Linux Web App Deployment mit Terraform (Principles of Cloud and DevOps Engineering)
Dieses Repository beinhaltet die Projektarbeit im Modul "Principles of Cloud and DevOps Engineering" an der Hochschule Aalen.

Folgende Anforderungen an das System wurden gestellt:

Scripted/ Runnable Terraform Definition(s) for a cloud application
• Application environment with web application on app service using keys from a key vault to read
and create file in storage account

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

Öffne die `main.tfvars` Datei und setze die Werte TENANT_ID, SUBSCRIPTION_ID, OBJECT_ID entsprechend deiner Azure-Konfiguration:
```hcl
## SHARED
TF_VAR_TENANT_ID       = "<your-tenant-id>"
TF_VAR_SUBSCRIPTION_ID = "<your-subscription-id>"
TF_VAR_LOCATION        = "northeurope"
TF_VAR_OBJECT_ID       = "<your-object-id>" #verfügbar über folgenden CLI COMMAND: "az ad signed-in-user show" (id)
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
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass #Falls benötigt
.\deploy_webapp_with_storage.ps1
```
**Wichtig: Bei einem Deployment Error unter Windows, Powershellskript nochmals ausführen!**

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
├── deploy_webapp_with_storage.sh (OSX Shell-Skript)
├── deploy_webapp_with_storage.ps1 (Windows Powershell-Skript)
└── README.md
```

## Erklärung der Dateien

- **main.tf**: Hauptkonfigurationsdatei, die die Ressourcengruppe definiert.
- **variables.tf**: Datei zur Deklaration der Variablen.
- **main.tfvars**: Datei zur Bereitstellung der Variablenwerte.
- **storage.tf**: Konfigurationsdatei für den Storage Account, sowie die Storage Container.
- **key_vault.tf**: Konfigurationsdatei für die Key-Vault + erstellen von Secrets.
- **app_service**: Konfigurationsdatei für den App Service Plan + Linux Web App.
- **deploy_webapp_with_storage.sh**: Shell-Skript zur Bereitstellung der Web-App und vorab Speicherung eines Text-Files in einem Blob. (MAC-Shell)
- **deploy_webapp_with_storage.ps1**: Powershell-Skript zur Bereitstellung der Web-App und vorab Speicherung eines Text-Files in einem Blob. (Windows Powershell)

## Wichtige Code-Abschnitte in der Web Applikation (Anforderungen an das System)

Kommunikation mit dem Key Vault:
Hierbei wurde der Flask-Secret-Key (definiert in key_vault.tf) aus dem Key-Vault gelesen und in der Flask-App initiiert.
```python
# Azure Key Vault configuration
key_vault_url = os.getenv('KEY_VAULT_URL')
secret_client = SecretClient(vault_url=key_vault_url, credential=credential)
flask_secret_key = secret_client.get_secret('flask-secret-key').value

#app.secret_key = 'SehrSaferKey'  # Needed for flashing messages
app.secret_key = flask_secret_key  # Needed for flashing messages
```

Erstellen und Lesen von Files:
Hierbei wurden Files in einem Blob im Container abgelegt und angezeigt.
```python
blob_service_client = BlobServiceClient(
        account_url= os.getenv('AZURE_STORAGE_ACCOUNT_URL'),
        credential=credential)

container_name = os.getenv('AZURE_STORAGE_CONTAINER_NAME')
container_client = blob_service_client.get_container_client(container_name)


@app.route('/')
def index():
    blob_list = container_client.list_blobs()
    blobs = [{"name": blob.name, "url": blob_service_client.get_blob_client(container_name, blob.name).url} for blob in blob_list]
    return render_template('index.html', blobs=blobs)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files or request.files['file'].filename == '':
        flash('Bitte wählen Sie eine Datei aus, bevor Sie auf "Upload" klicken.')
        return redirect(url_for('index'))
    
    file = request.files['file']
    blob_client = container_client.get_blob_client(file.filename)
    blob_client.upload_blob(file, overwrite=True)
    flash('Datei erfolgreich hochgeladen.')
    return redirect(url_for('index'))

@app.route('/download/<filename>', methods=['GET'])
def download_file(filename):
    blob_client = container_client.get_blob_client(filename)
    if blob_client.exists():
        download_stream = blob_client.download_blob()
        return send_file(io.BytesIO(download_stream.readall()), download_name=filename, as_attachment=True)
    return jsonify({"message": "File not found"}), 404
```

