# Meli-TF/terraform/environments/luisenv/main.tf

# Define the required Google Cloud provider.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

# Call our custom "cloudrun" module.
module "luis_test_app" {
  # Relative path to the module directory from this file.
  source = "../../modules/cloudrun"

  # --- Pass variables to the module ---

  # The GCP Project ID to deploy into.
  # !! MUST CHANGE THIS !!
  project_id = "TU_ID_DE_PROYECTO_GCP"

  location              = "us-central1"
  service_name          = "luis-env-test-app"
  image_name            = "gcr.io/cloud-run/hello" # Standard Google test image
  allow_unauthenticated = true                     # Make the service public
}

# Output the URL of the service after it's deployed.
output "service_url" {
  description = "The URL of the deployed test service."
  value       = module.luis_test_app.service_url
}