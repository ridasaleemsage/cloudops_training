terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  profile = "enplat-dev-admin"
  region  = var.aws_region
}

module "vpc" {
  # When using the module in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the module, such as the following example:
  # source = "git::git@github.com:sage-cloudops/terraform-aws-vpc.git//modules/vpc?ref=v0.0.1"
  source = "../../modules/vpc"

  aws_region  = var.aws_region
  app_name    = var.app_name
  environment = "staging"

  cidr                 = var.cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}