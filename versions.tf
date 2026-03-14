provider "aws" {
  region = var.region
}

terraform {
  backend "remote" {
    organization = "Varsentinel"
  }
  required_version = ">=1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.30"
    }
  }
}