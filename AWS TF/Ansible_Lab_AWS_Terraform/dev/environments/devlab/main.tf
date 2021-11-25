################################################
/*
Pre-reqs
  AWS Console account with cli access
  AWS CLI with profile configured and entered pelow
  Terraform V1.0.11(.terraform-version)
*/
################################################
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}
#requires aws configure and profile
provider "aws" {
 region = local.region
 shared_credentials_file = "/home/optikx/.aws/credentials" #change me
 profile = "default" #change me
}