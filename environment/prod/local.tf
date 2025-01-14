locals {
  name        = "webapp"
  environment = "prod"
  region      = "eu-west-1"
  cidr        = "10.0.0.0/16"
  subnets = [
    {
      type                    = "public"
      cidr                    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      availability_zone       = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
      map_public_ip_on_launch = true
    },
    {
      type              = "private"
      cidr              = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
      availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    }
  ]
  name_prefix = "${local.name}-${local.environment}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
