#=======================
#general 
#=======================
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1" #change me
}
variable "aws_account" {
  type        = string
  description = "AWS account"
  default = "null"
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
variable "s3_backend_name" {
  type = string
  description = "s3 bucket name for backent config"
  default     = "dev-lab-s3-bucket-321" #change me must match ../init/variables.tf > var s3_backend_name
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
    default = "~/build_keys/env/poc/" #change me
}
# optional keypath if not dynamically generated
variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub" #flagged for removal
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
  default     = "10.123.0.0/16" #change me
}
variable "vpc_public_subnets"{
  description = "list of public ips"
  type        = list(string)
  default     = ["10.123.1.0/24"] #change me
}
variable "vpc_private_subnets"{
  description = "list of private ips"
  type        = list(string)
  default     = ["10.123.2.0/24","10.123.3.0/24","10.123.4.0/24"] #change me
}
variable "vpc_db_subnets"{
  description = "list of db ips"
  type        = list(string)
  default     = ["10.123.5.0/24","10.123.6.0/24","10.123.7.0/24"] #change me
}
variable "vpc_tags" {
  description = "A map of tags to add to all vpcs"
  type        = map(string)
  default     = {
    module = "vpc" #update me
  }
}
#=======================
#sg vars
#=======================
variable "sg_tags" {
  description = "A map of tags to add to sg's"
  type        = map(string)
  default     = {
    module = "security-groups" #update me 
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
#Add more sg's for granulatiry
variable "remote_public_subnets"{
  description = "list of remote public ips"
  type        = list(string)
  default     = ["96.238.93.77/32","64.79.144.10/32"] #change me 
}
#=======================
#s3 variables
#=======================
variable "s3_bucket_media" {
  description = "name of s3 bucket for storing media"
  type        = string
  default     = "media" #change me
}
variable "s3_tags" {
  description = "A map of tags for ec2 instances"
  type        = map(string)
  default     = {
    module = "s3" #update if needed
  }
}
variable "s3_bucket_tools" {
  description = "name of s3 bucket for tools"
  type        = string
  default     = "tools" #change me
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
    module = "ec2-multi" #update if needed
  }
}
variable "ec2_bastion_role"{
  description = "Role of ec2 windows bastion instance"
  type        = string
  default     = "bastion" #change me 
}
variable "ec2_linux_role"{
  description = "Role of ec2 linux instance"
  type        = string
  default     = "app-rhel" #change me 
}
variable "ec2_windows_role"{
  description = "Role of ec2 windows instance"
  type        = string
  default     = "app-win" #change me 
}
variable "ec2_username" {
  type        = string
  description = "EC2 admin account name"
  default     = "svc_admin"    #change me
}
variable "bastion_username" {
  type        = string
  description = "bastion account name"
  default     = "jb_user"    #change me
}
#=======================
#rds variables
#=======================
variable "db_identifier" {
  description = "Database rds identifier name"
  type        = string
  sensitive   = true
  default     = "rds-db-cluster" #change me
}
variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
  default     = "db1" #change me
}
variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres" #change me
}
variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "11.10" #change me
}
variable "db_engine_family" {
  description = "Database engin parameter group"
  type        = string
  default     = "postgres11" #change me
}
variable "db_engine_major_version" {
  description = "Database engine major version"
  type        = string
  default     = "11" #change me
}
variable "db_engine_storage" {
  description = "Database engine storage gigs"
  type        = string
  default     = "50" #change me
}
variable "db_engine_max_storage" {
  description = "Database max storage"
  type        = string
  default     = "100" #change me
}
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
  default     = "rootdbuser" #change me
}
variable "db_tags" {
  description = "A map of tags for ec2 instances"
  type        = map(string)
  default     = {
    module = "rds" #update as needed
  }
}
#=======================
#ssm tags
#=======================
variable "ssm_win_config_name" {
  type        = string
  default     = "windows_script"
  description = "name for ssm to use for windows run commands"
}
variable "ssm_lin_config_name" {
  type        = string
  default     = "linux_script"
  description = "name for ssm to use for linux run commands"
}
variable "win_configure_service_1" {
  type        = string
  default     = "boot_win"
  description = "key for ssm to use for windows run commands"
}
variable "lin_configure_service_1" {
  type        = string
  default     = "boot_lin"
  description = "key for ssm to use for linux run commands"
}
variable "ssm_boot" {
  type        = string
  default     = "ssmTarget"
  description = "tag name for ssm boot targets"
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
    #additional = #"here"
  }
}
