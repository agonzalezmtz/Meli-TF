# Meli-TF/terraform/modules/firestore/variables.tf

variable "project_id" {
  description = "The GCP project ID where Firestore will be enabled."
  type        = string
}

variable "location" {
  description = "The location (region) for the Firestore database (e.g., 'us-central' or 'nam5'). This choice is permanent."
  type        = string
}

variable "enable_delete_protection" {
  description = "If set to true, protects the database from accidental deletion."
  type        = bool
  default     = true
}

variable "enable_pitr" {
  description = "If set to true, enables Point-in-Time Recovery."
  type        = bool
  default     = false
}
