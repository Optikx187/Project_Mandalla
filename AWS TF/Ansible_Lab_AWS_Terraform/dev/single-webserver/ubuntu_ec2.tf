terraform {
  required_version = ">= 0.12, < 0.14"
}

provider "aws" {
  region = "us-east-1"
  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_instance" "this_ec2" {
    #windows
    #ami           = "ami-027b1a16855fa3392"
    #ubuntu
    ami           = "ami-40d28157"
    instance_type = "t2.micro"
    tags          = {
        #import these
        Name = var.instance_name
    }
    #user_data = templatefile("./simple-web-server.bat", {uname = var.aws_ec2_uname, pass = var.aws_ec2_passwd})
    user_data = templatefile("./simple-web-server.sh.tpl", {port = var.server_port})
}
#output "public_ip" {
#    value = aws_instance.this_ec2.public_ip
#}
