module "vpc" {
  source = "../../modules/vpc"

  aws_region  = var.aws_region
  app_name    = var.app_name
  environment = "prod"

  cidr                 = var.cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}