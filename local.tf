locals {
  name        = "webapp"
  environment = "staging"
  region      = "eu-west-1"
  name_prefix = "${local.name}-${local.environment}}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}