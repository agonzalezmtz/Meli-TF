# Meli-TF/terraform/modules/firestore/main.tf

resource "google_firestore_database" "default" {
  project  = var.project_id
  
  # The name '(default)' is the standard database ID.
  name     = "(default)"
  
  # This choice is permanent.
  location_id = var.location

  # This is the key setting that makes it "Firestore" and not "Datastore Mode".
  type     = "FIRESTORE_NATIVE"

  # Use ternary operators to map simple booleans to the required string values.
  delete_protection_state = var.enable_delete_protection ? "DELETE_PROTECTION_ENABLED" : "DELETE_PROTECTION_DISABLED"

  point_in_time_recovery_enablement = var.enable_pitr ? "POINT_IN_TIME_RECOVERY_ENABLED" : "POINT_IN_TIME_RECOVERY_DISABLED"
}
