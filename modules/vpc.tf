# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-backend"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform_state"
#   }
# }

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/8"
  instance_tenancy = "default"
}
