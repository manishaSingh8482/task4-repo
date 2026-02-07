variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Allowed SSH CIDR block"
  type        = string
}
