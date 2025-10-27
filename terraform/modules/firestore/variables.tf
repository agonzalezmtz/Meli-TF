# Meli-TF/terraform/modules/firestore-enterprise/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location_id" {
  description = "The location for Firestore (e.g., 'us-central' or 'nam5'). THIS CANNOT BE CHANGED."
  type        = string
}

variable "database_name" {
  description = "The ID of the database to create (e.g., 'meli-mongo-db'). Cannot be '(default)' for Enterprise."
  type        = string
  
  validation {
    # Per the docs, Enterprise DBs cannot be '(default)'
    # and must be 4-63 chars.
    condition     = length(var.database_name) >= 4 && var.database_name != "(default)"
    error_message = "The database_name must be at least 4 characters long and cannot be '(default)'."
  }
}

variable "indexes" {
  description = "A list of composite indexes for the MongoDB compatibility API."
  type = list(object({
    collection = string
    fields = list(object({
      field_path = string
      order      = string # "ASCENDING" or "DESCENDING"
    }))
  }))
  default = []
}