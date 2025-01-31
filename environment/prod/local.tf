locals {
  name        = "webapp"
  environment = "prod"
  region      = "eu-west-1"
  cidr        = "10.0.0.0/16"
  s3_bucket   = "backend-tfstate"
  subnets = {
    public = [
      {
        cidr                    = "10.0.1.0/24"
        availability_zone       = "eu-west-1a"
        map_public_ip_on_launch = true
      },
      {
        cidr                    = "10.0.2.0/24"
        availability_zone       = "eu-west-1b"
        map_public_ip_on_launch = true
      }
    ],
    private = [
      {
        cidr              = "10.0.4.0/24"
        availability_zone = "eu-west-1a"
        tags = {
          Deployment = "v1"
          Release    = "1.3.0"
        }
      },
      {
        cidr              = "10.0.5.0/24"
        availability_zone = "eu-west-1b"
        tags = {
          Deployment = "v1"
          Release    = "1.3.0"
        }
      }
    ]
  }

  name_prefix = "${local.name}-${local.environment}"

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
