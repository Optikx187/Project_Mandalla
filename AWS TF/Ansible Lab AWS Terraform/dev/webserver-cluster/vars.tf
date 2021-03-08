##
##
variable "aws_region" {
    description = "region for tf code"
    type        = string
    default     = "us-east-1"
    }
##
variable "organization" {
    description = "organization"
    type        = string
    default     = "optkx"
    }
##
variable "environment" {
    description = "environment"
    type        = string
    default     = "dev"
    }
    
##ec2 name 
##
variable "instance_name" {
    description = "Name of EC2 instance"
    type        = string
    default     = "DELETE-ME"
    }
##ami id used for clustering
##
variable "ami_id" {
    description = "AMI used for web server"
    type        = string
    default     = "ami-40d28157"
    }
##instance type
##
variable "instance_type" {
    description = "Compute power/size of web server"
    type        = string
    default     = "t2.micro"
    }    
## SG, User_data
## Used to specify HTTP port (ingress)
variable "server_port" {
    description = "Name of HTTP request port"
    type        = string
    default     = "8080"
    }
## SG 
## Allow connection to web servers
variable "sg_http_name" {
    description = "Name of securitygroup for instance"
    type        = string
    default     = "DELETE-ME"
}
#sg name for alb
variable "sg_alb_name" {
    description = "Name of securitygroup for application load balancer"
    type        = string
    default     = "DELETE-ME"
}
##ELB
## Allows Auto Scaling Group(asg) to be reached from one hostname/public ip
variable "alb_name" {
    description = "Name of securitygroup for instance"
    type        = string
    default     = "DELETE-ME"
}
##LB port 
##
variable "lb_port" {
    description = "ingress port for lb"
    type        = string
    default     = "80"
}
##LB port 
##
variable "alb_sg_ingress" {
    description = "ingress port for elb sg"
    type        = string
    default     = "80"
}
##lb_proto
##
variable "lb_proto" {
    description = "ingress protocal for lb"
    type        = string
    default     = "http"
}
##
variable "instance_proto" {
    description = "instance protocal for lb"
    type        = string
    default     = "http"
}
##
variable "env" {
    description = "environment for terraform code"
    type        = string
    default     = "dev"
}
## Security 
##
variable "key_name" {
    description = "keypair name"
    type        = string
    default = "ec2Key"      # if we keep default blank it will ask for a value when we execute terraform apply
}
# base_path for refrencing 
variable "base_path" {
    description = "keypair file path"
    type        = string
    default = "/scripts/security"
}
##optional keypath if not dynamically generated
variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub"
}
##VPC
##
variable "vpc_name" {
  description = "name of vpc"
  type        = string
  default = "not-set-vpc"
}
## vpc cidr
variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "11.1.0.0/16"
}
## vpc public ip cidr
variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "11.1.1.0/24"
}
##
variable "public_subnet_name" {
  description = "Name for the public subnet"
  default = "public-sn"
}
## private ip cidr
variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "11.1.2.0/24"
}
## private subnet name 
variable "private_subnet_name" {
  description = "CIDR for the public subnet"
  default = "private-sn"
}
## internet gateway
##
variable "igw_name" {
  description = "Name of internet gateway"
  default = "vpc-igw"
}
## route table
variable "route_table_name" {
  description = "Name of public subnet route table"
  default = "public-sn-rt"
}
