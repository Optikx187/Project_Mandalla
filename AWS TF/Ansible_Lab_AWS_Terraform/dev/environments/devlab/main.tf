terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}

provider "aws" {
 region = "us-east-1"
 shared_credentials_file = "/home/optikx/.aws/credentials"
 profile = "default"
}