output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}

output "nat_gateways" {
  description = "List of NAT gateways in the VPC"
  value       = local.nat_gateways
}

output "private_subnets" {
  description = "List of private subnet objects in the VPC"
  value       = local.private_subnets
}

output "public_subnets" {
  description = "List of public subnet objects in the VPC"
  value       = local.public_subnets
}