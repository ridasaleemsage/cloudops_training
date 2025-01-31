output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = module.vpc.vpc_id
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = module.vpc.nat_gateways
}

output "private_subnets" {
  description = "List of private subnet objects in the VPC"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet objects in the VPC"
  value       = module.vpc.public_subnets
}
