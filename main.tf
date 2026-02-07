module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  project_name    = var.project_name
}

module "security" {
  source          = "./modules/security"
  vpc_id          = module.vpc.vpc_id
  allowed_ssh_ip  = var.allowed_ssh_ip
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  private_subnet_id = module.vpc.private_subnets[0]
  ec2_sg            = module.security.ec2_sg
  key_name          = var.key_name
}

module "alb" {
  source         = "./modules/alb"
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.security.alb_sg
  vpc_id         = module.vpc.vpc_id
}
