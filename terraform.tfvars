region    = "us-west-1"
project_name = "strapi-prod"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

instance_type = "t3.micro"

allowed_ssh_ip = "0.0.0.0/0"
