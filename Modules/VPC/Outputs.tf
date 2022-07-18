output "region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.my-vpc.id
}
output "public_subnet_1" {
  description = "Public Subnet 1"
  value       = aws_subnet.public-1.id
}
output "public_subnet_2" {
  description = "Public Subnet 2"
  value       = aws_subnet.public-2.id
}
output "private_subnet_1" {
  description = "Private Subnet 1"
  value       = aws_subnet.private-1.id
}
output "private_subnet_2" {
  description = "Private Subnet 2"
  value       = aws_subnet.private-2.id
}
output "database_subnet_1" {
  description = "Database Subnet 1"
  value       = aws_subnet.database-1.id
}
output "database_subnet_2" {
  description = "Database Subnet 2"
  value       = aws_subnet.database-2.id
}
output "Controller-sg_id" {
  description = "Security group IDs for Controller-sg"
  value       = [aws_security_group.controller-sg.id]
}
output "lb_security_group_id" {
  description = "Security group ID for lb-sg"
  value       = [aws_security_group.lb-sg.id]
}
output "asg-sg_id" {
  description = "Security group ID for Web-SG"
  value       = [aws_security_group.asg-sg.id]
}
output "EFS-sg_id" {
  description = "Security group ID for EFS-sg"
  value       = [aws_security_group.efs-sg.id]
}
output "MySQL-sg_id" {
  description = "Security group ID for MySQL-sg"
  value       = [aws_security_group.mysql-sg.id]
}
output "RDS-sg_id" {
  description = "Security group ID for RDS-sg"
  value       = [aws_security_group.rds-sg.id]
}
output "web-sg_id" {
  description = "Security group ID for web-sg"
  value       = [aws_security_group.web-sg.id]
}
# output "db_subnet_group" {
#   value = aws_db_subnet_group.db.id
# }