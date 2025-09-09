# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create SSH key pair in AWS from local public key
resource "aws_key_pair" "ssh" {
  key_name   = "aws_ec2_key_pair"
  public_key = var.public_key
}

# Security Group to allow traffic
resource "aws_security_group" "ec2_sg" {
  name        = "aws_ec2_sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "aws_ec2_sg"
  }
}

# Allow SSH
resource "aws_vpc_security_group_ingress_rule" "ssh_in" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow HTTP
resource "aws_vpc_security_group_ingress_rule" "http_in" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow HTTPS
resource "aws_vpc_security_group_ingress_rule" "https_in" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow Jenkins Web UI
resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# Create EC2 instance
resource "aws_instance" "resource_machine" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = {
    Name = "aws_ec2_machine"
  }
}