terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = var.tags
  }
}