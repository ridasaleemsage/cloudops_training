locals {
  name            = "webapp"
  environment     = "prod"
  region          = "eu-west-1"
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  name_prefix     = "${local.name}-${local.environment}"
  
  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
