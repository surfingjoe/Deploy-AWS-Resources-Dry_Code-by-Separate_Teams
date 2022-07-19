terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}
module "QA_vpc" {
  source = "../../modules/vpc"

  bucket                  = var.bucket
  state-key               = var.state-key
  dynamodb_table          = var.dynamodb_table
  bucket-region           = var.bucket-region
  region                  = var.region
  environment             = var.environment
  owner_name              = var.owner_name
  ec2-key                 = var.ec2-key
  instance_type           = var.instance_type
  ssh_location            = var.ssh_location
  enable_ipv6             = false
  enable_dns_support      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

}

module "Docker_web" {
  source = "../../modules/Docker_website"

  depends_on     = [module.QA_vpc]
  bucket         = var.bucket
  state-key      = var.state-key
  dynamodb_table = var.dynamodb_table
  bucket-region  = var.bucket-region
  region         = var.region
  environment    = var.environment
  owner_name     = var.owner_name
  ssh_location   = var.ssh_location
  ec2-key        = var.ec2-key
  instance_type  = var.instance_type
}