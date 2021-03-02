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

data "template_file" "user_data" {
  template = file("simple-web-server.sh")
  
  vars = {
    port       = var.server_port
    db_address = data.terraform_remote_state.db.address
    db_port    = data.terraform_remote_state.db.port

  }
}