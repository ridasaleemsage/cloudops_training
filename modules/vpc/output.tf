output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = local.nat_gateways
}

output "private_subnets_obj" {
  value = local.private_subnets
}

output "public_subnets_obj" {
  value = local.public_subnets
}
