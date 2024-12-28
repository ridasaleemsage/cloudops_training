output "vpc_id" {
  description = "Value of the VPC ID created"
  value       = aws_vpc.webapp.id
}