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
  # this should give you 
  private_formatted_list = "${formatlist("%s", var.vpc_private_subnets)}"
  db_formatted_list = "${formatlist("%s", var.vpc_db_subnets)}"

  # combine the formatted list of parameter together using join
  private_subnet_cidr = "${join(" ", local.private_formatted_list)}"
  db_subnet_cidr = "${join(" ", local.db_formatted_list)}"
}
#requires aws configure and profile
provider "aws" {
 region = local.region
 shared_credentials_file = "/home/optikx/.aws/credentials" #change me
 profile = "default" #change me
}