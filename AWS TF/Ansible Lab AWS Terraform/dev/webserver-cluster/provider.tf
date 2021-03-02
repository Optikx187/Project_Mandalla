  terraform {
  required_version = ">= 0.12, < 0.14"
}

provider "aws" {
    region= var.region
    # Allow any 2.x version of the AWS provider
    version = "~> 2.0"
}