module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  project_name    = var.project_name
}

module "security" {
  source = "./modules/security"

  vpc_id         = module.vpc.vpc_id
  allowed_ssh_ip = var.allowed_ssh_ip
}
module "ec2" {
  source = "./modules/ec2"

  instance_type     = var.instance_type
  private_subnet_id = module.vpc.private_subnets[0]
  ec2_sg            = module.security.ec2_sg
  key_name          = aws_key_pair.ec2_key.key_name
}
module "alb" {
  source         = "./modules/alb"
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.security.alb_sg
  vpc_id         = module.vpc.vpc_id
}
resource "aws_key_pair" "ec2_key" {
  key_name   = "strapi-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

resource "aws_security_group" "ssm_endpoint_sg" {
  name   = "ssm-endpoint-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/terraform-ec2-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}
