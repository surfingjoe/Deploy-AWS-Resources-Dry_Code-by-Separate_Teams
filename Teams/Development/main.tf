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
module "dev_vpc" {
  source = "../../modules/vpc"

  bucket               = var.bucket
  state-key            = var.state-key
  dynamodb_table       = var.dynamodb_table
  bucket-region        = var.bucket-region
  region               = var.region
  environment          = var.environment
  owner_name           = var.owner_name
  ec2-key              = var.ec2-key
  instance_type        = var.instance_type
  ssh_location         = var.ssh_location
  enable_ipv6          = var.enable_ipv6
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

module "Docker_web" {
  source = "../../modules/Docker_website"

  depends_on     = [module.dev_vpc]
  bucket         = var.bucket
  state-key      = var.state-key
  dynamodb_table = var.dynamodb_table
  bucket-region  = var.bucket-region
  region         = var.region
  environment    = var.environment
  owner_name     = var.owner_name
  ec2-key        = var.ec2-key
  instance_type  = var.instance_type
  ssh_location   = var.ssh_location
}