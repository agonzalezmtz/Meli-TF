# Meli-TF/terraform/modules/firestore-enterprise/outputs.tf

output "database_name" {
  description = "The full resource name of the Firestore Enterprise database."
  value       = google_firestore_database.database.name
}

output "database_id" {
  description = "The ID of the Firestore Enterprise database."
  value       = google_firestore_database.database.name
}

output "location_id" {
  description = "The location ID chosen for Firestore."
  value       = google_firestore_database.database.location_id
}