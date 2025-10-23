# Meli-TF/terraform/environments/luisenv/backend.tf

terraform {
  backend "gcs" {
    # The GCS bucket you created to store Terraform state files.
    # !! MUST CHANGE THIS !!
    bucket = "TU_BUCKET_DE_TFSTATE"

    # A unique "folder" path within the bucket for this specific environment.
    prefix = "terraform/env/luisenv"
  }
}