locals {
  name        = var.app_name
  environment = var.environment
  region      = var.aws_region
  cidr        = var.cidr
  name_prefix = "${local.name}-${local.environment}"

  private_subnets = { for idx, subnet in var.subnets["private"] : subnet.cidr => subnet }
  public_subnets  = { for idx, subnet in var.subnets["public"] : subnet.cidr => subnet }

  nat_gateways = {
    for subnet in var.subnets["private"] : subnet.availability_zone => {
      az           = subnet.availability_zone
      private_cidr = subnet.cidr
      public_cidr = lookup(
        { for public_subnet in var.subnets["public"] : public_subnet.availability_zone => public_subnet.cidr },
        subnet.availability_zone,
        null
      )
    }
  }

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
