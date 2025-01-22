variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
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
}
variable "environment" {
  description = "The environment to deploy the resources"
  type        = string
}
variable "tags" {
  description = "A map of tags to add in addition to the basic tags added by the module"
  type        = map(string)
  default     = {}
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "subnets" {
  description = "Subnet object to create"
  type = map(list(
    object({
      cidr                    = string
      availability_zone       = string
      map_public_ip_on_launch = optional(bool)
      tags                    = optional(map(string))
    })
    )
  )
  default = {
    "public" = [
      {
        cidr                    = "10.0.1.0/24"
        availability_zone       = "eu-west-1a"
        map_public_ip_on_launch = true
      }
    ],
    "private" = [
      {
        cidr              = "10.0.4.0/24"
        availability_zone = "eu-west-1a"
      }
    ]
  }
  validation {
    condition = length([for subnet_type, subnet in var.subnets : subnet if subnet_type == "public"]) >= length([for subnet_type, subnet in var.subnets : subnet if subnet_type == "private"])
        error_message = "Number of public subnets must be >= private subnets to support nat gateway creation."
  }
#   validation {
#     condition     = length([for subnet in var.subnets : subnet.cidr if subnet.key == "public"]) >= length([for subnet in var.subnets : subnet.cidr if subnet.key == "private"])
#     error_message = "Number of public subnets must be >= private subnets to support nat gateway creation."
#   }
#   validation {
#     condition = [for subnet in var.subnets :
#     sort(subnet.availability_zone) if subnet.type == "public"] == [for subnet in var.subnets : sort(subnet.availability_zone) if subnet.type == "private"]
#     error_message = "Both private and public subnet type must share same availability zones."
#   }
}