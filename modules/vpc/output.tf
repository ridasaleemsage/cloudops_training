output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}

output "public_subnets_with_azs" {
  description = "Value of public subnets with AZs"
  value       = local.public_subnets_with_azs
}

output "private_subnets_with_azs" {
  description = "Value of private subnets with AZs"
  value       = local.private_subnets_with_azs
}

output "public_subnets_by_azs" {
  description = "List of public subnets grouped by availability zones"
  value       = local.public_subnets_by_az
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = local.nat_gateways
}
