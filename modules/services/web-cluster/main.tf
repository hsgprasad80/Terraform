terraform {
  backend "s3" {
    bucket  = var.db_remote_state_bucket
    region  = var.aws_region
    profile = "guru"
    
    dynamodb_table = var.web_remote_state_lock
    encrypt        = true

    key = var.web_remote_state_key
  }
}

locals {
  http_port     = 80
  any_port      = 0
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  http_protocol = "http"
  all_ips       = ["0.0.0.0/0"]
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-sg"

  ingress {
    description = "Allow inbound HTTP request"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb-sg"

  ingress  {
    cidr_blocks = local.all_ips
    description = "Allow inbound HTTP request"
    from_port   = local.http_port
    protocol    = "tcp"
    to_port     = local.http_port
  }
  egress  {
    cidr_blocks = local.all_ips
    description = "allow outbound http request"
    from_port   = local.any_port
    protocol    = local.any_protocol
    to_port     = local.any_port
  }
}

#First create launch configuration
resource "aws_launch_configuration" "example" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  #user_data       = file("~/Desktop/terraform/user_data.sh")
  user_data       = data.template_file.user_data.rendered  
  lifecycle {
    create_before_destroy = true
  }
}

# data block to get default vpc-id
data "aws_vpc" "default" {
  default = true
}

#data block to get subnets of default vpc
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

#2nd create ASG itself
resource "aws_autoscaling_group" "example" {
  # Explicitly depends on the launch configuration's name so each time it's replaced
  # this ASG is also replaced
  name = "${var.cluster_name}-${aws_launch_configuration.example.name}"

  # you need to provide the name of launch config to use while creating ASG
  launch_configuration = aws_launch_configuration.example.name
  # specify the subnets where instances to be deployed
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  # attach the target group arn so that ASG can launch the resouces under TG
  target_group_arns = [aws_lb_target_group.asg.arn]
  # configure health check type
  health_check_type = "ELB"
  #min desired and max capacity of instances
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_size
  
  # when creating this ASG, create the replacement first and then 
  # only delete the orginal after. 
  lifecycle {
    create_before_destroy = true
  }

  # wait for atleast this many instances to pass health check before
  # considering the ASG deployment complete
  min_elb_capacity = var.min_size

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# autoscaling schedule to scale out and in depending on the time. 

resource "aws_autoscaling_schedule" "scale_out" {
  count = var.enable_autoscaling ? 1 : 0
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 1
  max_size = 5
  desired_capacity = 3
  recurrence = "0 9 * * *"

  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_schedule" "scale_in" {
  count = var.enable_autoscaling ? 1 : 0
  scheduled_action_name = "scale-in-during-business-hours"
  min_size = 1
  max_size = 3
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = aws_autoscaling_group.example.name
}

#setting cloud watch alarm based on the CPU utilization 
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  
  # if the first char is 't' under instance name then only alarm is created
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name = "${var.cluster_name}-low-cpu-credit-balance"
  namespace = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.example.name
  }
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}

#alb itself
resource "aws_lb" "example" {
  name               = "example-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]

}
#listiner for port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = local.http_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
#target group needs to be created
resource "aws_lb_target_group" "asg" {
  name     = "example-ASG-TG1"
  port     = var.server_port
  protocol = local.http_protocol
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = local.http_protocol
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
#listiner rule to route the traffic
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"] #path pattern is set to any
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# data block to read the state file for db endpoint and port
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket  = var.db_remote_state_bucket
    key     = var.db_remote_state_key
    region  = "us-east-1"
    profile = "guru"
  }
}
#data block which fetches details from remote state and writes to file
data "template_file" "user_data" {
  template = file("~/Desktop/terraform/user_data.sh")
  
  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    server_text = var.server_text
  }
}