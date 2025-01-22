output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = module.staging_vpc.vpc_id
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = module.staging_vpc.nat_gateways
}

output "private_subnets" {
  description = "List of private subnet objects in the VPC"
  value = module.staging_vpc.private_subnets_obj
}

output "public_subnets" {
  description = "List of public subnet objects in the VPC"
  value = module.staging_vpc.public_subnets_obj
}
