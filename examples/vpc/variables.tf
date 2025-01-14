# These parameters have reasonable defaults.

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
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
variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "eu-west-1"
}
variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "webapp"
}
variable "environment" {
  description = "The environment to deploy the resources"
  type        = string
  default     = "dev"
}
variable "subnets" {
  description = "Subnet object to create"
  type = list(object({
    type                    = string
    cidr                    = list(string)
    availability_zone       = list(string)
    map_public_ip_on_launch = optional(bool)
    })
  )
  default = [
    {
      type                    = "public"
      cidr                    = ["10.0.1.0/24"]
      availability_zone       = ["eu-west-1a"]
      map_public_ip_on_launch = true
    },
    {
      type              = "private"
      cidr              = ["10.0.4.0/24"]
      availability_zone = ["eu-west-1b"]
    }
  ]
}