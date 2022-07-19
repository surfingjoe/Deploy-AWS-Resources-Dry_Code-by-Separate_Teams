#--Get Terraform Remote State from Parent Module -------
data "terraform_remote_state" "Terraform-Remote-State" {
  backend = "s3"

  config = {
    bucket         = var.bucket
    key            = var.state-key
    region         = var.bucket-region
    dynamodb_table = var.dynamodb_table

  }
}
# ---  Get an AMI to use for NAT instance -------------
data "aws_ami" "amazon_nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
}
# ----------  Get current region data -----------------
data "aws_region" "current" {}
# ----------  Get availability zones ------------------
data "aws_availability_zones" "available" {
  state = "available"
}
# ------------------ Create the VPC -----------------------
resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name  = "My-VPC"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ----------------- Internet Gateway -----------------------
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name  = "${var.environment}-IGW"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ------------------ Setup Route table to IGW  -----------------
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name  = "${var.environment}-Public_route"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}

# ********************  Public Subnet **********************
# --------------------- Public Subnet #1 -------------------
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.public_cidr
  tags = {
    Name  = "public_subnet-1"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# --------------------- Public Subnet #2 ---------------------
resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = var.public_cidr2
  tags = {
    Name  = "public_subnet-2"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ----------- Associate route to IGW for public subnet #1 -------
resource "aws_route_table_association" "public-1-assoc" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-route.id
}
# -------- Associate route to IGW for public subnet #2 -------
resource "aws_route_table_association" "public-2-assoc" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-route.id
}
# **** Establish NAT Instances and Routes to NAT ***********
# --------------- Setup NAT Instance #1 --------------------
resource "aws_instance" "nat" {
  ami                         = data.aws_ami.amazon_nat.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public-1.id
  vpc_security_group_ids      = ["${aws_security_group.nat-sg.id}", "${aws_security_group.controller-sg.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  monitoring                  = true
  key_name                    = var.ec2-key
  tags = {
    Name  = "${var.environment}-NAT1"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# --------------- Setup NAT Instance #2 ------------------
resource "aws_instance" "nat2" {
  ami                         = data.aws_ami.amazon_nat.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public-2.id
  vpc_security_group_ids      = ["${aws_security_group.nat-sg.id}", "${aws_security_group.controller-sg.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  monitoring                  = true
  key_name                    = var.ec2-key
  tags = {
    Name  = "${var.environment}-NAT2"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ------------------ Setup Route to NAT  -----------------
resource "aws_route_table" "nat-route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # instance_id = aws_instance.nat.id
    network_interface_id = aws_instance.nat.primary_network_interface_id
  }
  tags = {
    Name  = "${var.environment}-route_to_nat1"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ------------------ Setup Route to NAT2  -----------------
resource "aws_route_table" "nat-route-2" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # instance_id = aws_instance.nat2.id
    network_interface_id = aws_instance.nat.primary_network_interface_id
  }
  tags = {
    Name  = "${var.environment}-route_to_nat2"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# ************* Create Private Subnets **********************
# --------------------- Private Subnet #1 -------------------
resource "aws_subnet" "private-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.private_cidr
  tags = {
    Name  = "private_subnet-1"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------- Associate private subnet 1 to NAT 1 route -------
resource "aws_route_table_association" "private-route-association" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.nat-route.id
}
# --------------------- Private Subnet #2 ---------------------
resource "aws_subnet" "private-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = var.private_cidr2
  tags = {
    Name  = "private_subnet-2"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------- Associate private subnet 2 to NAT 2 route -------
resource "aws_route_table_association" "private-route-association-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.nat-route-2.id
}

# *************  Create Database Subnet **********************
# --------------------- Database Subnet #1 -------------------
resource "aws_subnet" "database-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.database_cidr
  tags = {
    Name  = "database_subnet-1"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------- Associate database subnet 1 to NAT 1 route -------
resource "aws_route_table_association" "database-route-association" {
  subnet_id      = aws_subnet.database-1.id
  route_table_id = aws_route_table.nat-route.id
}
# --------------------- Database Subnet #2 ---------------------
resource "aws_subnet" "database-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = var.database_cidr2
  tags = {
    Name  = "database_subnet-2"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------- Associate database subnet 2 to NAT 2 route -------
resource "aws_route_table_association" "database-route-association-2" {
  subnet_id      = aws_subnet.database-2.id
  route_table_id = aws_route_table.nat-route-2.id
}
