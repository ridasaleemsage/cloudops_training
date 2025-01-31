terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

module "example_staging_vpc" {
  # When using the module in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the module, such as the following example:
  # source = "git::git@github.com:sage-cloudops/terraform-aws-vpc.git//modules/vpc?ref=v0.0.1"
  source = "../../modules/vpc"

  aws_region  = var.aws_region
  app_name    = "enplat"
  environment = "staging"

  cidr                 = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  s3_bucket            = "backend-tfstate"
  subnets = {
    public = [
      {
        cidr                    = "10.0.1.0/24"
        availability_zone       = "eu-west-1b"
        map_public_ip_on_launch = true
      }
    ],
    private = [
      {
        cidr              = "10.0.4.0/24"
        availability_zone = "eu-west-1b"
        tags = {
          Type = "private"
        }
      }
    ]
  }
}