################################################################################
# VPC Module
################################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = var.vpc_name 

  cidr = var.vpc_cidr 

  azs                 = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets     = var.vpc_private_subnets
  public_subnets      = var.vpc_public_subnets
  database_subnets    = var.vpc_db_subnets
 
  create_database_subnet_route_table    = true
  
  single_nat_gateway = true
  enable_nat_gateway = true

  enable_dns_hostnames = true

  tags = merge(
    {
      "Name" = "${var.environment}-${var.customer_name}"
      #"Name" = format("%s-dev", var.customer_name)
    },
    var.tags,
    var.vpc_tags,
  )
}
