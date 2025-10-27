# Meli-TF/terraform/modules/lb-regional-alb/variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "name_prefix" {
  description = "A prefix used to name all resources (e.g., 'meli-prod-app')."
  type        = string
}

variable "network" {
  description = "The self-link of the VPC network to deploy the LB in."
  type        = string
}

variable "region" {
  description = "The region to deploy this LB in (e.g., 'us-central1')."
  type        = string
}

variable "domain_names" {
  description = "A list of domain names for the Google-managed SSL certificate (e.Sg., ['app.meli.com'])."
  type        = list(string)
}

variable "backend_groups" {
  description = "A list of regional backend instance group (MIG) or network endpoint group (NEG) self-links."
  type        = list(string)
}

variable "static_ip_name" {
  description = "The name of the regional static IP to create. (e.g., 'meli-prod-lb-ip')."
  type        = string
}