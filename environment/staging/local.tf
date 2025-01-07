locals {
  name            = "darryl"
  environment     = "staging"
  region          = "eu-west-1"
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  name_prefix     = "${local.name}-${local.environment}"

  available_azs = data.aws_availability_zones.available.names

  # # Example alternatives to how we could structure subnet values
  # public_subnets_alt_1 = [
  #   {
  #     cidr = "10.0.1.0/24"
  #     az   = "eu-west-1a"
  #   },
  #   {
  #     cidr = "10.0.2.0/24"
  #     az   = "eu-west-1b"
  #   },
  #   {
  #     cidr = "10.0.3.0/24"
  #     az   = "eu-west-1c"
  #   }
  # ]
  # public_subnets_alt_2 = {
  #   "10.0.1.0/24" = "eu-west-1a"
  #   "10.0.2.0/24" = "eu-west-1b"
  #   "10.0.3.0/24" = "eu-west-1c"
  # }

  # Auto assign AZs to subnets for this approach. See possible alternative approaches above.
  # The modulo operator (%) cycles through the AZs when the number of subnets exceeds the number of AZs
  public_subnets_with_azs = {
    for i, cidr in local.public_subnets :
    cidr => local.available_azs[i % length(local.available_azs)]
  }
  private_subnets_with_azs = {
    for i, cidr in local.private_subnets :
    cidr => local.available_azs[i % length(local.available_azs)]
  }

  # Group the public subnets by AZ for efficient lookup
  public_subnets_by_az = { for cidr, az in local.public_subnets_with_azs : az => cidr }

  # Calculate required NAT Gateways for our private subnets and which public subnets in the same AZ to use
  nat_gateways = {
    for cidr, az in local.private_subnets_with_azs :
    az => {
      az           = az
      private_cidr = cidr
      # Find a matching public subnet in the same AZ
      # TODO: how does this handle failure, i.e. no matching az?
      public_cidr = local.public_subnets_by_az[az]
    }
  }

  base_tags = {
    Application = local.name,
    Environment = local.environment,
    Region      = local.region
  }
}
