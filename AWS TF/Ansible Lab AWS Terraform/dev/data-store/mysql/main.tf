terraform {
  required_version = ">= 0.12, < 0.14"
}
provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}
resource "aws_db_instance" "this_msql" {
  identifier_prefix   = "msqldb"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  username            = "admin"
  name                = var.db_name
  skip_final_snapshot = true
  password            = var.db_password
}