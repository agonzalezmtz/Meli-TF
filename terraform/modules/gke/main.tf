# Meli-TF/terraform/modules/gke/main.tf

# 1. The GKE Cluster (Control Plane)
resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location # This var controls Zonal vs. Regional deployment

  # --- Network Configuration ---
  network    = var.network_name
  subnetwork = var.subnetwork_name

  # --- Autopilot vs. Standard Logic (FIXED) ---
  #
  # We use a ternary operator to set one argument or the other to 'null'.
  # 'null' tells Terraform to completely ignore the argument,
  # which resolves the conflict.

  # If is_autopilot is true, set this to true.
  # If is_autopilot is false, set this to 'null' (ignored).
  enable_autopilot = var.is_autopilot ? true : null

  # --- Best Practice: Use Release Channels ---
  release_channel {
    channel = var.release_channel
  }

  # --- Best Practice: Remove the default node pool (FIXED) ---
  #
  # If is_autopilot is true, set this to 'null' (ignored).
  # If is_autopilot is false, set this to 'true' (as intended for Standard).
  remove_default_node_pool = var.is_autopilot ? null : true

  # --- Security Best Practice: Private Cluster ---
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Required for private clusters to be VPC-native
  ip_allocation_policy {
    # Let GCP handle the secondary ranges
  }

  # Disables access to the master from external IPs
  master_authorized_networks_config {
    # No networks listed, blocks all
  }

  # Enables monitoring and logging
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
}

# 2. The GKE Node Pool (Worker Nodes)
#    This resource will ONLY be created if 'var.is_autopilot' is 'false'.
#    (This section was already correct)
resource "google_container_node_pool" "primary_nodes" {
  # --- Conditional Creation Logic ---
  # If is_autopilot is true, count = 0 (no resource created)
  # If is_autopilot is false, count = 1 (this resource is created)
  count = var.is_autopilot ? 0 : 1

  name       = var.node_pool_name
  cluster    = google_container_cluster.primary.id
  location   = google_container_cluster.primary.location
  node_count = var.node_count

  # --- Node Configuration (This is where you define the machines) ---
  node_config {
    machine_type = var.node_machine_type # e.g., "e2-medium"
    disk_size_gb = var.node_disk_size_gb # e.g., 100
    disk_type    = var.node_disk_type    # e.g., "pd-standard" or "pd-ssd"
    preemptible  = var.node_preemptible  # Use Spot VMs

    # Standard GKE service account scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  # Autoscaling for the Standard node pool
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}