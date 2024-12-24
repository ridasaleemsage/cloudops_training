variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "enable_dns_hostnames" {
  description = "Indicates whether instances launched in the VPC get DNS hostnames"
  type        = bool
  default     = true
}
variable "enable_dns_support" {
  description = "Indicates whether the DNS resolution is supported for the VPC"
  type        = bool
  default     = true
}