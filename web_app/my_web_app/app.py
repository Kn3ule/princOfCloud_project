from flask import Flask, request, jsonify, send_file, render_template, redirect, url_for, flash
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import os
import io
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

credential = DefaultAzureCredential()
# Azure Key Vault configuration
key_vault_url = os.getenv('KEY_VAULT_URL')
secret_client = SecretClient(vault_url=key_vault_url, credential=credential)
flask_secret_key = secret_client.get_secret('flask-secret-key').value

#app.secret_key = 'SehrSaferKey'  # Needed for flashing messages
app.secret_key = flask_secret_key  # Needed for flashing messages

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

if __name__ == '__main__':
    app.run()
