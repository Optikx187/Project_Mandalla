#security groups explicitly allows traffic to services
resource "aws_security_group" "this_websg" {

    name = var.sg_http_name
    vpc_id = aws_vpc.default.id
    ingress  {
        description = "Allow incomeing http, https, and ssh"
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  # ingress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
    lifecycle {
            create_before_destroy = true
    }

  tags = {
    Description = "allow http"
    from_port   = var.server_port #harden
    to_port     = var.server_port #harden
  }
}
#application load balancer sg
resource "aws_security_group" "this_alb" {

    name = var.sg_alb_name
    #allow inbound
    ingress  {
        description = "allow traffic to alb from specified port"
        from_port   = var.alb_sg_ingress
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    #allow outbound - needed for elb health check
    egress {
        from_port   = 0 
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    lifecycle {
            create_before_destroy = true
    }

  tags = {
    Description = "allow from alb to instance"
    from_port   = var.alb_sg_ingress #harden
    to_port     = var.server_port #harden
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgdb" {
  name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306 #dbport
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "TEST-DB-SG"
  }
}