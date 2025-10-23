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
  description = "Ingress traffic controls. e.g., INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY or INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  type        = string
  default     = "INGRESS_TRAFFIC_ALL" # Default to public
}

variable "invoker_iam_disabled" {
  description = "Enable public access without validate an IAM policy"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "image_name" {
  description = "The full path to the container image (e.g., 'gcr.io/my-project/my-image:latest')."
  type        = string
}

variable "cpu" {
  description = "The amount of CPU to use in the container."
  type        = number
  default     = 1
}

variable "memory" {
  description = "The amount of memory RAM to use in the container. "
  type        = string
  default     = "512 Mi"
}

variable "max_instance_count" {
  description = "The amount of maximum instances for the container "
  type        = number
  default     = 100
}

variable "min_instance_count" {
  description = "The amount of minimum instances for the container "
  type        = number
  default     = 0
}

variable "container_concurrency" {
  description = "The amount of maximum concurrency for the container (As Maximum 1000) "
  type        = number
  default     = 80
}

variable "container_port" {
  description = "The port your container listens on."
  type        = number
  default     = 8080
}

# variable "allow_unauthenticated" {
#   description = "If true, allows public, unauthenticated access to the service."
#   type        = bool
#   default     = false
# }

# variable "environment_variables" {
#   description = "A map of environment variables to set in the container."
#   type        = map(string)
#   default     = {}
# }
