variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}
