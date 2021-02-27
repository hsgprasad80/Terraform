# creates auto scaling group and registers instance to target group
data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "test-asg" {
  name                 = "Test-ASG"
  launch_configuration = aws_launch_configuration.asg-config.id
  target_group_arns    = [aws_lb_target_group.TG1.arn]
  health_check_type    = "ELB"
  min_size             = "1"
  max_size             = "2"
  desired_capacity     = "2"
  vpc_zone_identifier  = aws_subnet.Private_subnets.*.id
  health_check_grace_period = "60"
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "my-terraform-asg-example"
  }
}

# creates launch configuration

resource "aws_launch_configuration" "asg-config" {
  name            = "asg_lc"
  image_id        = var.redhatami
  instance_type   = var.instance_type_micro
  security_groups = [aws_security_group.ASG_sg.id]
  key_name        = var.Privkey_name
  lifecycle {
    create_before_destroy = false
  }
}

# user data for ASG instances
#data "userdata_file" "test" {
#  template = <<-EOF
#    #!/bin/bash
#     sudo yum update -y
#     sudo yum install tree -y
#     mkdir /tmp/test
#  EOF
#}
