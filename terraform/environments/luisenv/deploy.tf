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
module "test_meli_service" {
  # Relative path to the module directory from this file.
  source = "../../modules/cloudrun"

  # --- Pass variables to the module ---

  # The GCP Project ID to deploy into.
  # CHANGE THIS 
  project_id = "1034146075509"

  location              = "us-central1"
  service_name          = "test-meli"
  image_name            = "us.docker.pkg.dev/cloud-run/hello" # Standard Google test image
  allow_unauthenticated = true                     # Make the service public
  container_port = 8080
  environment_variables = {}
}


# Output the URL of the service after it's deployed.
output "service_url" {
  description = "The URL of the deployed test service."
  value       = module.test_meli_service.service_url
}