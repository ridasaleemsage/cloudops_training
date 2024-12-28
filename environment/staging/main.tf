module "vpc" {
  source = "../../modules/vpc"

  aws_region  = local.region
  app_name    = local.name
  environment = "staging"

  cidr                 = local.cidr
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  enable_dns_support   = true
  enable_dns_hostnames = true
}
