terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}
locals {
  region = "us-east-1"
}
#requires aws configure and profile
provider "aws" {
 region = locals.region
 shared_credentials_file = "/home/optikx/.aws/credentials" #change me
 profile = "default" #change me
}