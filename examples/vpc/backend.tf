terraform {
  backend "s3" {
    bucket         = "backend-tfstate"
    key            = "examples/vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "backend-tflock"
    encrypt        = true
  }
}