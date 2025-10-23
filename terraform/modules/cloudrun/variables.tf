# Meli-TF/terraform/modules/cloudrun/variables.tf

variable "project_id" {
  description = "The GCP project ID where the service will be deployed."
  type        = string
}

variable "location" {
  description = "The GCP region for the service (e.g., 'us-central1')."
  type        = string
}

variable "deletion_protection" {
  description = "If true, protects the Cloud Run service from accidental deletion."
  type        = bool
  default     = true # Default to ON for safety
}

variable "ingress_settings" {
  description = "Ingress traffic controls. e.g., INGRESS_TRAFFIC_ALL or INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  type        = string
  default     = "INGRESS_TRAFFIC_ALL" # Default to public
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "image_name" {
  description = "The full path to the container image (e.g., 'gcr.io/my-project/my-image:latest')."
  type        = string
}

variable "allow_unauthenticated" {
  description = "If true, allows public, unauthenticated access to the service."
  type        = bool
  default     = false
}

variable "container_port" {
  description = "The port your container listens on."
  type        = number
  default     = 8080
}

variable "environment_variables" {
  description = "A map of environment variables to set in the container."
  type        = map(string)
  default     = {}
}
