variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-02d26659fd82cf299"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "public_key" {
  description = "SSH public key for EC2"
  type        = string
}

variable "root_volume_size" {
  type    = number
  default = 30
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}