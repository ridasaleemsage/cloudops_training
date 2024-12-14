resource "aws_vpc" "webapp" {
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name}-${local.environment}"
    }
  )
}
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)

  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.public_subnets, each.value))
  vpc_id                  = aws_vpc.webapp.id
  map_public_ip_on_launch = true

  tags = merge(
    local.base_tags,
    {
      Name = "public-${each.value}"
    }
  )
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.webapp.id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name}-igw"
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
      Name = "public-${aws_internet_gateway.public.id}"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)

  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnets, each.value))
  vpc_id            = aws_vpc.webapp.id

  tags = merge(
    local.base_tags,
    {
      Name = "private-${each.value}"
    }
  )
}

resource "aws_eip" "private" {
  for_each = aws_subnet.public
  domain   = "vpc"
  tags = merge(
    local.base_tags
    # {
    #   Name = "${local.name}-${each.value.id}"
    # }
  )
}

resource "aws_nat_gateway" "private" {
  for_each = toset(var.public_subnets)

  allocation_id = aws_eip.private[each.value].id
  subnet_id     = aws_subnet.public[each.value].id # Assuming you're associating it with a public subnet

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name}-${aws_eip.private[each.value].public_ip}"
    }
  )

  depends_on = [aws_internet_gateway.public]
}

resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.private
  vpc_id   = aws_vpc.webapp.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "private-nat-${each.value.public_ip}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = zipmap(var.private_subnets, var.public_subnets)

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value].id
}