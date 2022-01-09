terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "ido-terraform-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Environment = "IdoTest"
      Name        = "IdoZiv"
      ManagedBy   = "Terraform"
    }
  }
}