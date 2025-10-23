# Meli-TF/terraform/modules/cloudrun/main.tf

# 1. The Cloud Run Service Resource
resource "google_cloud_run_v2_service" "default" {
  name     = var.service_name
  location = var.location
  project  = var.project_id

  deletion_protection = var.deletion_protection

  # Defines the "template" for new revisions
  template {
    containers {
      image = var.image_name

      ports {
        container_port = var.container_port
      }

      # This dynamic block loops over the 'environment_variables' map
      # and creates an 'env' block for each key/value pair.
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  # This ensures the service routes 100% of traffic to the latest revision
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# 2. The IAM Policy for Public Access
# This resource is created CONDITIONALLY.
resource "google_cloud_run_service_iam_member" "public_invoker" {
  # 'count' is the magic: if var.allow_unauthenticated is 'true', count = 1 (create it).
  # If 'false', count = 0 (do not create it).
  count = var.allow_unauthenticated ? 1 : 0

  location = google_cloud_run_v2_service.default.location
  project  = google_cloud_run_v2_service.default.project
  service  = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"

  # Depends on the service being created first
  depends_on = [google_cloud_run_v2_service.default]
}
