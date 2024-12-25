locals {
  name        = var.app_name
  environment = "prod"
  region      = var.aws_region
  name_prefix = "${local.name}.${local.environment}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }

  # Create a map of route table IDs keyed by the "AZ" tag
  route_table_map = {
    for id, rt in aws_route_table.private : rt.tags.AZ => rt.id
  }
}