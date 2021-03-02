data "aws_availability_zones" "all" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
  #tags = { Name = "public" } 
}