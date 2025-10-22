# Meli-TF/terraform/modules/firestore/outputs.tf

output "database_name" {
  description = "The full resource name of the Firestore database."
  value       = google_firestore_database.default.name
}

output "location_id" {
  description = "The location of the database."
  value       = google_firestore_database.default.location_id
}

output "database_uid" {
  description = "The unique ID of the database."
  value       = google_firestore_database.default.uid
}

output "key_prefix" {
  description = "The prefix for all keys in this database."
  value       = google_firestore_database.default.key_prefix
}
