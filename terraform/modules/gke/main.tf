# Meli-TF/terraform/modules/gke/main.tf

resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location

  # --- Network Configuration ---
  network    = var.network_name
  subnetwork = var.subnetwork_name

  # --- Autopilot vs. Standard Logic ---
  # If true, GKE ignores the node_config and initial_node_count below.
  # If false, GKE uses them to build the default node pool.
  enable_autopilot = var.is_autopilot

  # --- Standard Node Pool Configuration ---
  # This block is only used if 'enable_autopilot' is false.
  initial_node_count = var.node_initial_count
  node_config {
    machine_type = var.node_machine_type
    
    # Standard GKE service account scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  # --- Security Best Practice: Private Cluster ---
  # This configuration ensures nodes have no public IPs and the
  # master is only accessible via its private endpoint.
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # This is required for private clusters to be VPC-native
  ip_allocation_policy {
    # Let GCP handle the secondary ranges
  }

  # Disables access to the master from external IPs
  master_authorized_networks_config {
    # No networks listed, blocks all
  }
}
