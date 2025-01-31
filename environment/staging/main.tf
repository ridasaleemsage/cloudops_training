module "vpc" {
  # When using the module in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the module, such as the following example:
  # source = "git::git@github.com:sage-cloudops/terraform-aws-vpc.git//modules/vpc?ref=v0.0.1"
  source = "../../modules/vpc"

  aws_region  = local.region
  app_name    = local.name
  environment = local.environment

  cidr                 = local.cidr
  subnets              = local.subnets
  enable_dns_support   = true
  enable_dns_hostnames = true
  s3_bucket            = local.s3_bucket

  tags = local.base_tags
}