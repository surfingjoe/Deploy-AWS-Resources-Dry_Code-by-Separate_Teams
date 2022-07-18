variable "bucket" {}
variable "state-key" {}
variable "dynamodb_table" {}
variable "region" {}
variable "bucket-region" {}
variable "ec2-key" {}
variable "instance_type" {}
variable "ssh_location" {}
variable "environment" {}
variable "owner_name" {
  description = "Name to be used on all the resources as deployment owner"
  type        = string
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
}
