variable "region" {
  type = string
}

variable "project_name" {}
variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "instance_type" {}


variable "allowed_ssh_ip" {}
