# Meli-TF/terraform/modules/gke/outputs.tf

output "cluster_name" {
  description = "The name of the created GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "The location (region or zone) of the cluster."
  value       = google_container_cluster.primary.location
}

output "cluster_endpoint" {
  description = "The private endpoint of the GKE cluster master."
  value       = google_container_cluster.primary.private_cluster_config[0].private_endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The base64 encoded cluster CA certificate."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pool_name" {
  description = "The name of the created node pool (null if Autopilot)."
  # This ternary gracefully handles Autopilot (where no node pool is created)
  value = var.is_autopilot ? null : google_container_node_pool.primary_nodes[0].name
}

output "is_autopilot" {
  description = "True if the cluster is an Autopilot cluster."
  value       = google_container_cluster.primary.enable_autopilot
}