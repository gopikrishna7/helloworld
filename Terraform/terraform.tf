terraform {
  required_version = ">= 1.0" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  
    }
  }
  backend "s3" {
    bucket = "terraform-bucket-ex"
    key = "terraform.tfstate"
    region = "us-west-2"
    
  }
}

provider "aws" {
  region = "us-west-2"
}