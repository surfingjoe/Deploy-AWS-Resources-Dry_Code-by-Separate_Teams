# -------------- Security Group for Controller -----------------------
resource "aws_security_group" "controller-sg" {
  name        = "ssh"
  description = "allow SSH from MyIP"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.ssh_location}"]

  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "SSH_SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for NAT instances --------------------
resource "aws_security_group" "nat-sg" {
  name        = "nat-sg"
  description = "Allow traffic to pass from the private subnet to the internet"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.private_cidr}", "${var.private_cidr2}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.private_cidr}", "${var.private_cidr2}"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.controller-sg.id}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Name  = "NAT-Sg"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for ASG  -----------------------------
resource "aws_security_group" "asg-sg" {
  name        = "ASG-SG"
  description = "allow SSH from Load Balancer and Controller"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.controller-sg.id}"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb-sg.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "ASG-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for Load Balancer --------------------
resource "aws_security_group" "lb-sg" {
  name        = "LB-SG"
  description = "allow HTTP and HTTPS"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "LB-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for EFS ------------------------------
resource "aws_security_group" "efs-sg" {
  name   = "ingress-efs-sg"
  vpc_id = aws_vpc.my-vpc.id

  // NFS
  ingress {
    security_groups = ["${aws_security_group.mysql-sg.id}", "${aws_security_group.asg-sg.id}"]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  egress {
    security_groups = ["${aws_security_group.mysql-sg.id}", "${aws_security_group.asg-sg.id}"]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name  = "EFS-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for MySQL ---------------------------
resource "aws_security_group" "mysql-sg" {
  name        = "MySQL-SG"
  description = "allow SSH from Controller and MySQL from web servers"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.controller-sg.id}"]
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = ["${aws_security_group.asg-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "MySQL-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for RDS -----------------------------
resource "aws_security_group" "rds-sg" {
  name        = "RDS-SG"
  description = "allow mysql protocol from web servers"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = ["${aws_security_group.asg-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "RDS-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}
# -------------- Security Group for Web Server in Public Network ----
resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "allow HTTP and HTTPS"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Web-SG"
    Stage = "${var.environment}"
    Owner = "${var.owner_name}"
  }
}