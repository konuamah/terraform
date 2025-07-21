
# =============================================================================
# ROOT MODULE - main.tf
# =============================================================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  availability_zone    = var.availability_zone
  environment          = var.environment
  project_name         = var.project_name
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"
  
  vpc_id       = module.vpc.vpc_id
  environment  = var.environment
  project_name = var.project_name
}

# EC2 Instances Module
module "ec2" {
  source = "./modules/ec2"
  
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  public_subnet_id          = module.vpc.public_subnet_id
  private_subnet_id         = module.vpc.private_subnet_id
  public_security_group_id  = module.security_groups.public_security_group_id
  private_security_group_id = module.security_groups.private_security_group_id
  environment               = var.environment
  project_name              = var.project_name
}