# Meli-TF/terraform/modules/lb-regional-alb/main.tf

# --- 1. Reserve a Regional Static IP ---
resource "google_compute_address" "default" {
  project = var.project_id
  name    = var.static_ip_name
  region  = var.region
  address_type = "EXTERNAL"
}

# --- 2. Create the Health Check (Global, but used by regional service) ---
resource "google_compute_health_check" "default" {
  project = var.project_id
  name    = "${var.name_prefix}-http-check"
  http_health_check {
    port               = 80
    request_path       = "/"
    port_specification = "USE_SERVING_PORT"
  }
}

# --- 3. Create the Regional Backend Service ---
resource "google_compute_region_backend_service" "default" {
  project               = var.project_id
  name                  = "${var.name_prefix}-backend-svc"
  region                = var.region
  protocol              = "HTTP" # The LB proxy handles HTTPS termination
  load_balancing_scheme = "EXTERNAL_MANAGED" # This makes it a Regional External ALB
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.default.id]

  # Loop over the list of instance groups/NEGs provided
  dynamic "backend" {
    for_each = toset(var.backend_groups)
    content {
      group           = backend.value
      balancing_mode  = "UTILIZATION"
      capacity_scaler = 1.0
    }
  }
}

# --- 4. Create the Regional URL Maps (routes traffic) ---
resource "google_compute_region_url_map" "https_redirect" {
  project = var.project_id
  name    = "${var.name_prefix}-http-redirect-map"
  region  = var.region
  # This map handles HTTP, redirecting everything to HTTPS
  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_region_url_map" "default" {
  project         = var.project_id
  name            = "${var.name_prefix}-https-map"
  region          = var.region
  # This map handles HTTPS, sending traffic to the backend service
  default_service = google_compute_region_backend_service.default.id
}

# --- 5. Create the Regional SSL Certificate (Google-Managed) ---
resource "google_compute_region_ssl_certificate" "default" {
  project = var.project_id
  name    = "${var.name_prefix}-ssl-cert"
  region  = var.region
  domains = var.domain_names
}

# --- 6. Create the Regional Target Proxies (The "Front Door") ---
resource "google_compute_region_target_http_proxy" "http_redirect" {
  project = var.project_id
  name    = "${var.name_prefix}-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.https_redirect.id
}

resource "google_compute_region_target_https_proxy" "default" {
  project = var.project_id
  name    = "${var.name_prefix}-httpss-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.id
  ssl_certificates = [
    google_compute_region_ssl_certificate.default.id
  ]
}

# --- 7. Create the Regional Forwarding Rules (The IP address) ---
resource "google_compute_forwarding_rule" "http" {
  project               = var.project_id
  name                  = "${var.name_prefix}-fwd-rule-http"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_redirect.id
  ip_address            = google_compute_address.default.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = var.network
}

resource "google_compute_forwarding_rule" "httpss" {
  project               = var.project_id
  name                  = "${var.name_prefix}-fwd-rule-https"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.default.id
  ip_address            = google_compute_address.default.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = var.network
}