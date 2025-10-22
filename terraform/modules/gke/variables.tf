# Meli-TF/terraform/modules/gke/variables.tf

variable "project_id" {
  description = "The GCP project ID to deploy the cluster into."
  type        = string
}

variable "cluster_name" {
  description = "The name for the GKE cluster."
  type        = string
}

variable "location" {
  description = "The GCP region for the GKE cluster (e.g., 'us-central1')."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network to deploy the cluster into."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork to deploy the cluster into."
  type        = string
}

variable "is_autopilot" {
  description = "Set to true to create an Autopilot cluster. If false, creates a Standard cluster."
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The /28 IP range for the GKE master control plane (required for private clusters)."
  type        = string
}

# --- Standard Cluster Variables ---
# These are ignored if 'is_autopilot' is true.

variable "node_machine_type" {
  description = "The machine type for the default node pool."
  type        = string
  default     = "e2-standard-4"
}

variable "node_initial_count" {
  description = "The initial number of nodes for the default node pool."
  type        = number
  default     = 1
}
