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
      Name = "${local.name_prefix}-private-ngw-${each.key}",
      AZ   = each.key
    }
  )

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

  # This prevents errors if a route table isn't found for a subnet
  depends_on = [aws_route_table.private]
}
