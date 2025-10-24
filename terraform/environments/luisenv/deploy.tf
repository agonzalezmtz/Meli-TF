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
  location                  = "us-central1"
  service_name              = "test-meli"
  image_name                = "docker.io/nginx:latest" # Standard Google test image
  cpu                       = 2      
  memory                    = "1Gi"
  min_instance_count        = 0
  max_instance_count        = 100
  max_instance_request_concurrency    = 80
  container_port            = 80
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


# Call our custom "GKE" module.
module "test_meli_gkecluster-standard" {
  # Relative path to the module directory from this file.
  source = "../../modules/gke"

  # --- General Cluster Settings ---
  project_id   = "1034146075509"
  cluster_name = "meli-gke"    
  location     = "us-central1" 

  # --- Network Settings (REPLACE THESE VALUES) ---
  network_name           = "meli-vpc-test"
  subnetwork_name        = "meli-gke-nodes"
  master_ipv4_cidr_block = "172.16.0.0/28" # It must be CIDR Range /28

  # --- Deployment Type (Standard) ---
  is_autopilot = false # CHECK THIS 'enable_autopilot'

  # --- Standard Node Pool Settings (ENABLE in case of is_autopilot=false) ---
  node_pool_name    = "gke-pool-meli"
  node_count        = 1                 
  node_machine_type = "e2-medium"       
  node_disk_size_gb = 50
  node_disk_type    = "pd-standard"
  node_preemptible  = false
}


# # Call our custom "GKE" module to create an AUTOPILOT cluster
# module "test_meli_gkecluster_autopilot" {
#   source = "../../modules/gke"

#   # --- General Cluster Settings ---
#   project_id   = "1034146075509"
#   cluster_name = "meli-gke-autopilot" 
#   location     = "us-central1"        # It must be regional

#   # --- Network Settings (DEBES CAMBIAR ESTOS VALORES) ---
#   network_name           = "my-vpc-network"
#   subnetwork_name        = "my-gke-subnet"
#   master_ipv4_cidr_block = "172.16.0.0/28"

#   # --- Deployment Type (Autopilot) ---
#   is_autopilot = true 
# }