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
output "database_subnet_1" {
  description = "Database Subnet 1"
  value       = module.dev_vpc.database_subnet_1
}
output "database_subnet_2" {
  description = "Database Subnet 2"
  value       = module.dev_vpc.database_subnet_2
}
output "Controller-sg_id" {
  description = "Security group IDs for Controller-sg"
  value       = module.dev_vpc.Controller-sg_id
}
output "lb_security_group_id" {
  description = "Security group ID for lb-sg"
  value       = module.dev_vpc.lb_security_group_id
}
output "asg-sg_id" {
  description = "Security group ID for ASG-SG"
  value       = module.dev_vpc.asg-sg_id
}
output "EFS-sg_id" {
  description = "Security group ID for EFS-sg"
  value       = module.dev_vpc.EFS-sg_id
}
output "MySQL-sg_id" {
  description = "Security group ID for MySQL-sg"
  value       = module.dev_vpc.MySQL-sg_id
}
output "RDS-sg_id" {
  description = "Security group ID for RDS-sg"
  value       = module.dev_vpc.MySQL-sg_id
}
output "Web-IP" {
  description = "Security group ID for RDS-sg"
  value       = module.Docker_web.Web_IP
}
# output "db_subnet_group" {
#   value = module.dev_vpc.db_subnet_group
# }