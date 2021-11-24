#=======================
#general 
#=======================
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
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
  default     = "dev-vpc" #change me 
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
  default     = ["10.123.2.0/24","10.123.3.0/24"]
}
variable "vpc_db_subnets"{
  description = "list of db ips"
  type        = list(string)
  default     = ["10.123.4.0/24"]
}
variable "vpc_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    VPC = "TRUE"
  }
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
