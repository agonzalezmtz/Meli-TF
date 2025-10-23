# Meli-TF/terraform/environments/luisenv/deploy.tf

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
  project_id = "1034146075509"

  location                          = "us-central1"
  service_name                      = "test-meli"
  image_name                        = "docker.io/nginx:latest" # Standard Google test image
  cpu                               = 2      
  memory                            = "1Gi"
  max_instance_count                = 0
  max_instance_count                = 100
  max_instance_request_concurrency  = 80
  container_port                    = 80
  

  deletion_protection  = false
  ingress_settings     = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  invoker_iam_disabled = true

  #allow_unauthenticated = true                     # Not neccesary for now
  #environment_variables = {}
}


# Output the URL of the service after it's deployed.
output "service_url" {
  description = "The URL of the deployed test service."
  value       = module.test_meli_service.service_url
}