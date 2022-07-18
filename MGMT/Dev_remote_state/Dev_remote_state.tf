provider "aws" {
  region = "<your_region>"
}
# ------------ configure remote state  ------------------------------
terraform {
  backend "s3" {
    bucket = "<your_bucket_name>-terraform-states"
    key    = "development-terraform.tfstate"
    region = "<your_region>"
  }
}