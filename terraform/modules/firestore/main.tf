# Meli-TF/terraform/modules/firestore-enterprise/main.tf

# 1. Define the Firestore Database (Enterprise Edition)
# Assumes 'firestore.googleapis.com' API is already enabled.
resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = var.database_name
  location_id = var.location_id # e.g., "us-central" or "nam5"

  # --- This is the key for your request ---
  edition = "ENTERPRISE"
  type    = "MONGODB_COMPATIBILITY_MODE"
  # ----------------------------------------

  # Explicitly disable the App Engine link (Best Practice)
  app_engine_integration_mode = "DISABLED"
}

# 2. (Optional) Create MongoDB-Compatible Indexes
dynamic "google_firestore_index" "default" {
  # Create an index for each item in the 'indexes' variable
  for_each = { for idx in var.indexes : idx.collection => idx }

  content {
    project    = var.project_id
    database   = google_firestore_database.database.name
    collection = google_firestore_index.value.collection

    # Specify that this index is for the MongoDB API
    api_scope = "MONGODB_COMPATIBLE_API"

    dynamic "fields" {
      for_each = google_firestore_index.value.fields
      content {
        field_path = fields.value.field_path
        order      = fields.value.order
      }
    }
  }
}