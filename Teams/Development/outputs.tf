output "region" {
  description = "AWS region"
  value       = module.dev_vpc.region
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.dev_vpc.vpc_id
}
output "public_subnet_1" {
  description = "Public Subnet 1"
  value       = module.dev_vpc.public_subnet_1
}
output "public_subnet_2" {
  description = "Public Subnet 2"
  value       = module.dev_vpc.public_subnet_2
}
output "private_subnet_1" {
  description = "Private Subnet 1"
  value       = module.dev_vpc.private_subnet_1
}
output "private_subnet_2" {
  description = "Private Subnet 2"
  value       = module.dev_vpc.private_subnet_2
}
output "NAT_sg_id" {
  description = "Security group ID for mat-sg"
  value       = module.dev_vpc.NAT_sg_id
}
output "Web-IP" {
  description = "Security group ID for RDS-sg"
  value       = module.Docker_web.Web_IP
}
