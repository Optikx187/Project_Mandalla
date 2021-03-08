# vpc
resource "aws_vpc" "this_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }

  enable_dns_hostnames = true
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = "aws_vpc.default.id"
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.public_subnet_name
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = "aws_vpc.default.id"
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = var.private_subnet_name
  }
}
# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "aws_vpc.default.id"

  tags = {
    Name = var.igw_name
  }
}
# Define the route table
resource "aws_route_table" "web_public_rt" {
  vpc_id = "aws_vpc.default.id"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.gw.id"
  }

  tags = {
    Name = var.route_table_name
  }
}
# Assign the route table to the public Subnet
resource "aws_route_table_association" "web_public_rt" {
  subnet_id = "aws_subnet.public_subnet.id"
  route_table_id = "aws_route_table.web_public_rt.id"
}
