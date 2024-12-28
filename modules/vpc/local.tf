locals {
  name        = var.app_name
  environment = var.environment
  region      = var.aws_region
  name_prefix = "${local.name}.${local.environment}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }

  route_table_map = { for id, rt in aws_route_table.private : rt.tags.AZ => rt.id }
}