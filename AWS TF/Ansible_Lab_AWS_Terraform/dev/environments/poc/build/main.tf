################################################
/*
Pre-reqs
  AWS Console account with cli access
  AWS CLI with profile configured and entered below
  Terraform V1.0.11(.terraform-version)
  secrets directory needs to ebe created for pem files
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