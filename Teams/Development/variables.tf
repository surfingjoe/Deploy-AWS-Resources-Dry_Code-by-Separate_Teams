variable "bucket" {
  description = "Name of the S3 bucket that will be holding Terraform Remote State"
  type        = string
}
variable "state-key" {
  description = "Name of the file for the terraform state key"
  type        = string
}
variable "dynamodb_table" {
  description = "Name to be assigned to the DynamoDB table"
  type        = string
}
variable "region" {
  description = "Region where VPC will be located"
  type        = string
}
variable "bucket-region" {
  description = "Region where S3 bucket is placed"
  type        = string
}
variable "ec2-key" {
  description = "Regional EC2 key used by the team"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "ssh_location" {
  description = "CIDR block allowed SSH access into resource"
  type        = string
}
variable "environment" {
  description = "Identify the Team's Environment i.e. QA or Development"
  type        = string
}
variable "owner_name" {
  description = "Name to be used on all the resources as deployment owner"
  type        = string
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "map_public_ip_on_launch" {
  description = "Whether to map the public IP on launch. "
  type        = bool
  default     = true
}
