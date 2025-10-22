# Meli-TF/terraform/modules/cloudrun/outputs.tf

output "service_url" {
  description = "The URL of the deployed service."
  # We get the 'uri' attribute directly from our resource
  value       = google_cloud_run_v2_service.default.uri
}

output "service_name" {
  description = "The name of the service."
  value       = google_cloud_run_v2_service.default.name
}

output "latest_revision" {
  description = "The name of the latest ready revision."
  value       = google_cloud_run_v2_service.default.latest_ready_revision_name
}
