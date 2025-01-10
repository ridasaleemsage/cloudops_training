output "public_subnets_with_azs" {
  value = local.public_subnets_with_azs
}

output "private_subnets_with_azs" {
  value = local.private_subnets_with_azs
}

output "public_subnets_by_azs" {
  value = local.public_subnets_by_az
}

output "nat_gateways" {
  value = local.nat_gateways
}
