output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnets"
  value       = aws_subnet.private[*].id
}
