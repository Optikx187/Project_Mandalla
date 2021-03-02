data "aws_availability_zones" "all" {}
##
##
data "aws_vpc" "default" {
  default = true
}
##
##
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
##Pull from backend config
##
data "terraform_remote_state" "db" {
  backend = "s3"
  config  = {
     bucket = "dev-tf-state-storage"
     key    = "mysql/terraform.tfstate"
     region = "us-east-1"
  }
}