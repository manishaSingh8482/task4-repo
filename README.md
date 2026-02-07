# Secure Private Strapi Deployment on AWS using Terraform

This project deploys a production-grade Strapi application on AWS using Terraform.

## Architecture
- VPC with public and private subnets
- NAT Gateway for private outbound internet
- Application Load Balancer in public subnets
- Private EC2 instance running Strapi via Docker
- PostgreSQL database running in Docker
- IAM + SSM for secure access (no SSH required)

## Application Flow
Internet → ALB → Private EC2 → Strapi (Port 1337)

## Technologies Used
- Terraform
- AWS (VPC, EC2, ALB, IAM, SSM)
- Docker
- Strapi v4
- PostgreSQL

## Files Overview
| File | Purpose |
|----|----|
| provider.tf | AWS provider configuration |
| variables.tf | Input variable definitions |
| terraform.tfvars | Environment values |
| main.tf | Infrastructure resources |
| user_data.sh | Bootstraps EC2 with Docker & Strapi |
| README.md | Documentation |

## Deployment Steps

1. Configure AWS credentials
```bash
aws configure
