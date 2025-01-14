output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = module.vpc.vpc_id
}

output "public_subnets_with_azs" {
  description = "Value of public subnets with AZs"
  value       = module.vpc.public_subnets_with_azs
}

output "private_subnets_with_azs" {
  description = "Value of private subnets with AZs"
  value       = module.vpc.private_subnets_with_azs
}

output "public_subnets_by_azs" {
  description = "List of public subnets grouped by availability zones"
  value       = module.vpc.public_subnets_by_azs
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = module.vpc.nat_gateways
}

output "private_subnets_obj" {
  value = module.vpc.private_subnets_obj
}
output "public_subnets_obj" {
  value = module.vpc.public_subnets_obj
}

