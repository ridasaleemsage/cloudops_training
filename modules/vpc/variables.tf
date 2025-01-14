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
      cidr                    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      availability_zone       = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
      map_public_ip_on_launch = true
    },
    {
      type              = "private"
      cidr              = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
      availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    }
  ]
  validation {
    condition = alltrue([
      for subnet in var.subnets :
      length(subnet.cidr) == length(subnet.availability_zone)
    ])
    error_message = "Each subnet must have the same number of CIDR blocks and availability zones."
  }
  validation {
    condition     = length([for subnet in var.subnets : subnet.cidr if subnet.type == "public"]) >= length([for subnet in var.subnets : subnet.cidr if subnet.type == "private"])
    error_message = "Number of public subnets must be >= private subnets to support nat gateway creation."
  }
  # TBD: Add validation to ensure that each subnet type shares the same availability zones.
  validation {
    condition     = alltrue([])
    error_message = "Each subnet type must share same availability zones."
  }
}