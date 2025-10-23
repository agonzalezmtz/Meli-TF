# Meli-TF/terraform/modules/gke/variables.tf

# --- Cluster-Wide Variables ---
variable "project_id" {
  description = "The GCP project ID to deploy the cluster in."
  type        = string
}

variable "cluster_name" {
  description = "The name for the GKE cluster."
  type        = string
  default     = "gke-cluster"
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster (e.g., 'us-central1' for Regional, 'us-central1-a' for Zonal)."
  type        = string
}

variable "release_channel" {
  description = "The release channel for the cluster. (RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

# --- Network Variables ---
variable "network_name" {
  description = "The name of the VPC network to attach the cluster to."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork to attach the cluster to."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The /28 IP range for the private cluster master."
  type        = string
}

# --- Control Variable (Autopilot vs Standard) ---
variable "is_autopilot" {
  description = "If true, creates an Autopilot cluster (ignores node pool variables). If false, creates a Standard cluster."
  type        = bool
  default     = false
}

# --- Standard Mode Node Pool Variables ---
# These variables are ONLY used if 'is_autopilot' is set to 'false'.

variable "node_pool_name" {
  description = "The name of the node pool for Standard clusters."
  type        = string
  default     = "default-pool"
}

variable "node_count" {
  description = "The initial number of nodes in the node pool (for Standard)."
  type        = number
  default     = 1
}

variable "node_machine_type" {
  description = "The machine type for the nodes (e.g., 'e2-medium') (for Standard)."
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size_gb" {
  description = "The boot disk size (in GB) for nodes (for Standard)."
  type        = number
  default     = 100
}

variable "node_disk_type" {
  description = "The boot disk type for nodes ('pd-standard' or 'pd-ssd') (for Standard)."
  type        = string
  default     = "pd-standard"
}

variable "node_preemptible" {
  description = "If true, use preemptible (Spot) VMs for nodes (for Standard)."
  type        = bool
  default     = false
}