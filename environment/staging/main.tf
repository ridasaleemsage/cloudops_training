resource "aws_vpc" "webapp" {
  cidr_block           = local.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets_with_azs

  vpc_id                  = aws_vpc.webapp.id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-public-sn-${replace(replace(each.value, ".", "-"), "/", "-")}"
      AZ   = each.value
    }
  )
  
  # This precondition would likely be replaced with variable validation in the VPC module version
  lifecycle {
    precondition {
      condition = length(local.public_subnets) >= length(local.private_subnets)
      error_message = "Number of public subnets must be >= private subnets to support nat gateway creation. You specified ${length(local.private_subnets)} private subnets but only ${length(local.public_subnets)} public subnets."
    }
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.webapp.id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-igw-${local.region}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.webapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets_with_azs

  vpc_id            = aws_vpc.webapp.id
  cidr_block        = each.key
  availability_zone = each.value

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-private-sn-${replace(replace(each.value, ".", "-"), "/", "-")}",
      AZ   = each.value

    }
  )
}

resource "aws_eip" "ngw" {
  for_each = local.nat_gateways

  domain = "vpc"

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-ngw-eip-${each.value.az}"
    }
  )
}

resource "aws_nat_gateway" "private" {
  for_each = local.nat_gateways

  allocation_id = aws_eip.ngw[each.key].id
  subnet_id     = aws_subnet.public[each.value.public_cidr].id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-ngw-${each.key}",
      AZ   = each.key
    }
  )

  # Fail early if no public subnet available in this AZ.
  # Prob overkill to validate this when we control and hardcode the subnet values here as locals, however it may be more useful when converting to a module later (this and/or variable validation)
  lifecycle {
    precondition {
      condition = each.value.public_cidr != null
      error_message = "Unable to create nat gateway for ${each.key} - no public subnet available in this AZ. Make sure number of public subnets >= private subnets."
      
    }
  }

  # Ensure NAT Gateway is created after Internet Gateway
  depends_on = [aws_internet_gateway.public]
}

resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.private

  vpc_id = aws_vpc.webapp.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}-private-rt-${local.nat_gateways[each.key].az}",
      AZ   = local.nat_gateways[each.key].az
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.availability_zone].id
}
