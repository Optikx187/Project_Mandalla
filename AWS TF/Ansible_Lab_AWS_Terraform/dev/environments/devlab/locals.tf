locals {
  region = "us-east-1"
  #format strign lists
  private_formatted_list = "${formatlist("%s", var.vpc_private_subnets)}"
  public_formatted_list = "${formatlist("%s", var.vpc_public_subnets)}"
  db_formatted_list = "${formatlist("%s", var.vpc_db_subnets)}"
  remote_formatted_list = "${formatlist("%s", var.remote_public_subnets)}"
  # combine the formatted list of parameter together using join
  private_subnet_cidr = "${join(",", local.private_formatted_list)}"
  db_subnet_cidr = "${join(",", local.db_formatted_list)}"
  public_subnet_cidr = "${join(",", local.public_formatted_list)}"
  remote_subnet_cidr = "${join(",", local.remote_formatted_list)}"


}