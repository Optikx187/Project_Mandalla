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
variable "key_name_ec2" {
    description = "keypair name"
    type        = string
    default = "env-ec2"      # change me
}
variable "key_name_root" {
    description = "root key for ssc"
    type        = string
    default = "env-root"      # change me
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
variable "key_tags" {
  description = "A map of tags to add to keys"
  type        = map(string)
  default     = {
    module = "security"
  }
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
    module = "security-groups"
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
#ec2 variables
#=======================
variable "ec2_name_windows"{
  description = "Name of ec2 windows instance"
  type        = string
  default     = "windows" #change me 
}
variable "ec2_name_linux"{
  description = "Name of ec2 linux instance"
  type        = string
  default     = "linux" #change me 
}
variable "ec2_name_bastion"{
  description = "Name of ec2 windows bastion instance"
  type        = string
  default     = "bastion" #change me 
}
variable "ec2_tags" {
  description = "A map of tags for ec2 instances"
  type        = map(string)
  default     = {
    module = "ec2-multi"
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
    Environment = "dev" #change me
    Owner       = "mygroup" #change me
  }
}
