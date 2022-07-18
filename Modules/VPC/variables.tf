variable "bucket" {}
variable "state-key" {}
variable "dynamodb_table" {}
variable "region" {}
variable "bucket-region" {}
variable "ec2-key" {}
variable "instance_type" {}
variable "ssh_location" {}
variable "environment" {}
variable "owner_name" {}
variable "enable_ipv6" {type = bool}
variable "enable_dns_hostnames" {type = bool}
variable "enable_dns_support" {type = bool}
variable "av-zone1" { default = "us-west-1a" }
variable "av-zone2" { default = "us-west-1c" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_cidr" { default = "10.0.1.0/24" }
variable "public_cidr2" { default = "10.0.2.0/24" }
variable "private_cidr" { default = "10.0.101.0/24" }
variable "private_cidr2" { default = "10.0.102.0/24" }
variable "database_cidr" { default = "10.0.31.0/24" }
variable "database_cidr2" { default = "10.0.32.0/24" }
variable "intranet_cidr" { default = "10.0.31.0/24" }
variable "intranet_cidr2" { default = "10.0.32.0/24" }
