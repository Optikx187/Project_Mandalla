#security groups explicitly allows traffic to services
resource "aws_security_group" "this_sg" {

    name = var.sg_http_name
    ingress  {
        description = "HTTP from public ip to server"
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
        description = "allow traffic to elb from specified port"
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
