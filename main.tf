module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ec2" {
  source            = "./modules/ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  private_subnet_id = module.vpc.private_subnets[0]
  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.alb.alb_sg_id
}
