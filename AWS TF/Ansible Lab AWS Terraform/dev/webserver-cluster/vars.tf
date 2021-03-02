##
##
variable "region" {
    description = "region for tf code"
    type        = string
    default     = "us-east-1"
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
