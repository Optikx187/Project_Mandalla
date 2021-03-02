resource "aws_launch_configuration" "this_asg_lc" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data = templatefile("./simple-web-server.sh.tpl", {port = var.server_port})

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "this_asg" {

    launch_configuration = aws_launch_configuration.this_asg_lc.id
    vpc_zone_identifier  = data.aws_subnet_ids.default.ids
    target_group_arns = [aws_lb_target_group.this_asg_tar.arn] # add
    #availability_zones = data.aws_availability_zones.all.names 
    desired_capacity = 2
    force_delete = true
    #allow elb health check for generated instances
    #look into this
    health_check_type = "ELB"
    health_check_grace_period = 300
    #placement_group = "value"
    #vpc_zone_identifier = [ "value" ]
    min_size = 2
    max_size = 10
    tag {
        key       = "Name"
        value     = "ASG-TEST"
        propagate_at_launch = true
    }
    tag {
        key       = "TEST1"
        value     = "TEST2"
        propagate_at_launch = true
    }

}
resource "aws_lb" "this_lb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.this_alb.id]
}
resource "aws_lb_listener" "this_http" {
  load_balancer_arn = aws_lb.this_lb.arn
  port              = var.lb_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
resource "aws_lb_target_group" "this_asg_tar" {
  name = var.alb_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener_rule" "this_asg_lb_rule" {
  listener_arn = aws_lb_listener.this_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_asg_tar.arn
  }
}