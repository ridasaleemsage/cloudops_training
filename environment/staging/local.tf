locals {
  name        = "webapp"
  environment = "staging"
  region      = "eu-west-1"
  cidr        = "10.0.0.0/16"
  subnets = [
    {
      type                    = "public"
      cidr                    = ["10.0.3.0/24"]
      availability_zone       = ["eu-west-1b"]
      map_public_ip_on_launch = true
    },
    {
      type              = "private"
      cidr              = ["10.0.4.0/24"]
      availability_zone = ["eu-west-1b"]
    }
  ]
  name_prefix = "${local.name}-${local.environment}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
