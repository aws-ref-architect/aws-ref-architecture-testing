variable "vpc_name" {
    description = "Name for default VPC."
    default = "default"
}

variable "environment" {
  description = "Name of environment (eg. development, staging, production)."
}

variable "domain_name" {
  description = "Name of domain used for published app (eg. staging.risczero-aws.com)."
  default = "development.risczero-aws.internal"
}

variable "aws_region" {
    description = "Primary AWS region for the cloud components."
    default = "us-west-1"
}

variable "vpc_cidr" {
    description = "IP block used for underlying VPC."
    default = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "Availability zones (AZs) used by cloud."
    default = ["us-west-1a", "us-west-1b", "us-west-1c"]
}

variable "internal_subnets" {
  description = "List of internal-only subnets - requires 3."
  default     = ["10.1.0.0/19" ,"10.1.64.0/19", "10.1.128.0/19"]
}

variable "external_subnets" {
  description = "List of external-only subnets - requires 3."
  default     = ["10.2.0.0/19", "10.2.64.0/19", "10.2.128.0/19"]
}

variable "aws_account_id" {
  description = "AWS account used to maintain the game app."
  default = "1234567890"
}

module "vpc" {
  source             = "./modules/vpc"
  name               = "${var.vpc_name}"
  cidr               = "${var.vpc_cidr}"
  internal_subnets   = "${var.internal_subnets}"
  external_subnets   = "${var.external_subnets}"
  availability_zones = "${var.availability_zones}"
  environment        = "${var.environment}"
}

module "dynamo_terraform" {
  source = "./modules/dynamodb"
}

module "s3_logging" {
  source = "./modules/s3/logging"
}

module "s3_website_staging" {
  source = "./modules/s3/website"
  bucket_name = "staging-game"
  aws_account_id = "${var.aws_account_id}"
}

module "s3_website_production" {
  source = "./modules/s3/website"
  bucket_name = "production-game"
  aws_account_id = "${var.aws_account_id}"
}

module "app_staging" {
  source = "./modules/s3/app"
  bucket_name = "staging-game"
  environment = "staging"
}

module "app_production" {
  source = "./modules/s3/app"
  bucket_name = "production-game"
  environment = "production"
}

module "waf_staging" {
  source = "./modules/waf"
  bucket_name = "staging-game"
  environment = "staging"
}

module "waf_production" {
  source = "./modules/waf"
  bucket_name = "production-game"
  environment = "production"
}