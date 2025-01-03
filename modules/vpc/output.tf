output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}
output "private_subnets" {
  description = "List of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}
output "public_subnets" {
  description = "List of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}