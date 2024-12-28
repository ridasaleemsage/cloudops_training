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