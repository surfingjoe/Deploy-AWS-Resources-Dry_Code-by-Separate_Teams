#------------------------- State terraform backend location---------------------
data "terraform_remote_state" "Terraform-State" {
  backend = "s3"

  config = {
    bucket         = var.bucket
    key            = var.state-key
    region         = var.bucket-region
    dynamodb_table = var.dynamodb_table
  }
}
# ----------------------- Get existing VPC ----------------------------
data "aws_vpcs" "vpc" {
  tags = {
    Stage = var.environment
    Name  = "My-VPC"
  }
}
# ----------------------- Get region data ----------------------------

data "aws_region" "current" {}

# ----------------------- Get existing Public Subnet -----------------
data "aws_subnet" "public_subnets" {

  tags = {
    Stage = var.environment
    Name  = "public_subnet-1"
  }
}
# ---- Get existing Security Group for Web server -------------------
data "aws_security_group" "web-sg" {

  tags = {
    Stage = var.environment
    Name  = "Web-SG"
  }
}

#------------------------ Get most recent Amazon Linux2 image -----------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
# -------------------- Creating Web Server -----------------------------------
resource "aws_instance" "web-server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.public_subnets.id
  vpc_security_group_ids = [data.aws_security_group.web-sg.id]
  #subnet_id              = data.terraform_remote_state.dev_vpc.outputs.public_subnet_1
  #vpc_security_group_ids = [data.terraform_remote_state.dev_vpc.outputs.web-sg_id]

  user_data = file("${path.module}/bootstrap_docker_web.sh")
  #user_data  = file("bootstrap_docker_web.sh")
  monitoring = true
  key_name   = var.ec2-key

  tags = {
    Name  = "Web-Server"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}