#=======================
#general 
#=======================
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}
variable "customer_name"{
  description = "Name for resources created by the vpc module"
  type        = string
  default     = "customer" #change me 
}
variable "environment"{
  description = "name of environment"
  type        = string
  default     = "dev" #change me 
}
#=======================
#backend config var
#=======================
variable "s3_name" {
  type = string
  description = "s3 bucket name for backent config"
  default     = "dev-lab-s3-bucket-temp"
}
#=======================
# Security 
#=======================
variable "key_name" {
    description = "keypair name"
    type        = string
    default = "devenv"      # change me
}
# base_path for refrencing 
variable "base_path" {
    description = "keypair file path"
    type        = string
    default = "/scripts/security" #change me
}
##optional keypath if not dynamically generated
variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub"
}
#=======================
#vpc vars
#=======================
variable "vpc_name"{
  description = "Name of VPC"
  type        = string
  default     = "vpc-dev" #change me 
}
variable "vpc_cidr" {
  description = "cidr for vpc"
  type        = string
  default     = "10.123.0.0/16"
}
variable "vpc_public_subnets"{
  description = "list of public ips"
  type        = list(string)
  default     = ["10.123.1.0/24"]
}
variable "vpc_private_subnets"{
  description = "list of private ips"
  type        = list(string)
  default     = ["10.123.2.0/24","10.123.3.0/24","10.123.4.0/24"]
}
variable "vpc_db_subnets"{
  description = "list of db ips"
  type        = list(string)
  default     = ["10.123.5.0/24","10.123.6.0/24","10.123.7.0/24"]
}
variable "vpc_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    module = "vpc"
  }
}
#=======================
#sg vars
#=======================
variable "sg_tags" {
  description = "A map of tags to add to sg's"
  type        = map(string)
  default     = {
    module = "security_groups"
  }
}
variable "private_subnet_sg" {
  description = "private subnet sg name"
  type        = string
  default     = "private_sn_routing"
}
variable "public_subnet_sg" {
  description = "public subnet sg name"
  type        = string
  default     = "public_sn_routing"
}
variable "remote_public_subnets"{
  description = "list of remote public ips"
  type        = list(string)
  default     = ["96.238.93.77/32"] #change me 
}
#=======================
#general tags
#=======================
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    IaaC        = "terraform"
    Environment = "dev"
  }
}
