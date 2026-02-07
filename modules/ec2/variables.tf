variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "ec2_sg" {
  description = "EC2 security group ID"
  type        = string
}

variable "key_name" {
  type        = string
  description = "SSH key pair name for EC2"
}

