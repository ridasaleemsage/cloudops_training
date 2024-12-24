resource "aws_vpc" "webapp" {
  cidr_block           = local.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.base_tags,
    {
      Name = replace("${local.name_prefix}.vpc", "[/]", ".")
    }
  )
}

resource "aws_subnet" "public" {
  for_each = toset(local.public_subnets)

  cidr_block = each.value
  # The `element` function is used to wrap around the number of public subnets to ensure that the code does not break even 
  # if the number of subnets exceeds the number of availability zones.
  availability_zone       = element(data.aws_availability_zones.available.names, index(local.public_subnets, each.value))
  vpc_id                  = aws_vpc.webapp.id
  map_public_ip_on_launch = true

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.public.${each.value}.sn"
      AZ   = element(data.aws_availability_zones.available.names, index(local.public_subnets, each.value))
    }
  )
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.webapp.id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.${local.region}.igw"
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
      Name = "${local.name_prefix}.public.${aws_internet_gateway.public.id}.rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each = toset(local.private_subnets)

  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(local.private_subnets, each.value))
  vpc_id            = aws_vpc.webapp.id

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.private.${each.value}.sn",
      AZ   = element(data.aws_availability_zones.available.names, index(local.private_subnets, each.value))

    }
  )
}

resource "aws_eip" "private" {
  for_each = aws_subnet.public
  domain   = "vpc"
  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.${each.value.availability_zone_id}.ngw.eip"
    }
  )
}

resource "aws_nat_gateway" "private" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.private[each.value.cidr_block].id
  subnet_id     = each.value.id # Assuming you're associating it with a public subnet

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.${aws_eip.private[each.value.cidr_block].public_ip}.ngw",
      AZ   = "${each.value.availability_zone}"
    }
  )

  # Ensure NAT Gateway is created after Internet Gateway
  depends_on = [aws_internet_gateway.public]
}

resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.private
  vpc_id   = aws_vpc.webapp.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.name_prefix}.private.nat.${each.value.public_ip}.rt",
      AZ   = "${each.value.tags.AZ}"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id

  # Ensure both route tables and subnets share the same "Availablity Zone" tag 
  route_table_id = lookup(local.route_table_map, each.value.tags["AZ"], null)

  # This prevents errors if a route table isn't found for a subnet
  depends_on = [aws_route_table.private]
}
