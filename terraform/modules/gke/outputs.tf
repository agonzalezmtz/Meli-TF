# Meli-TF/terraform/modules/gke/outputs.tf

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "location" {
  description = "The location (region) of the GKE cluster."
  value       = google_container_cluster.primary.location
}

output "private_endpoint" {
  description = "The private IP address of the GKE cluster's control plane."
  value       = google_container_cluster.primary.private_endpoint
  sensitive   = true # IPs should be treated as sensitive
}

output "ca_certificate" {
  description = "The cluster's root certificate (base64 encoded) for auth."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true # Certificates are secrets
}
