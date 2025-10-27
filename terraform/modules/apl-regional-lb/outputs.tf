# Meli-TF/terraform/modules/lb-regional-alb/outputs.tf

output "ip_address" {
  description = "The static regional IP address of the load balancer."
  value       = google_compute_address.default.address
  sensitive   = true
}

output "backend_service_name" {
  description = "The name of the regional backend service."
  value       = google_compute_region_backend_service.default.name
}

output "ssl_certificate_name" {
  description = "The name of the Google-managed regional SSL certificate."
  value       = google_compute_region_ssl_certificate.default.name
}

output "httpss_proxy_name" {
  description = "The name of the regional HTTPS target proxy."
  value       = google_compute_region_target_https_proxy.default.name
}