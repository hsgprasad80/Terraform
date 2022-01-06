# creates auto scaling group and registers instance to target grou

resource "aws_autoscaling_group" "test-asg" {
  name                      = "Test-ASG"
 #launch_configuration      = aws_launch_configuration.asg-config.id
  launch_template {
         id = aws_launch_template.template.id
    version = "$Latest"
  }
  target_group_arns         = [aws_lb_target_group.TG1.arn]
  health_check_type         = "ELB"
  min_size                  = "1"
  max_size                  = "3"
  desired_capacity          = "2"
  vpc_zone_identifier       = aws_subnet.Private_subnets.*.id
  health_check_grace_period = "60"
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "my-terraform-asg-example"
  }
  lifecycle {
   create_before_destroy = false
  }
}

# creates launch configuration

// Launch config 
# resource "aws_launch_configuration" "asg-config" {
#   name            = "asg_lc"
#   image_id        = var.redhatami
#   instance_type   = var.instance_type_micro
#   security_groups = [aws_security_group.ASG_sg.id]
#   key_name        = var.Privkey_name
#   user_data       = file("~/Desktop/terraform/init_script.sh")
#   lifecycle {
#     create_before_destroy = false
#   }
# }

data "template_file" "test" {
  template = file("~/Desktop/terraform/init_ubuntu.sh")
}
//launch template
resource "aws_launch_template" "template" {
  name            = "demo-template"
  image_id        = var.ubuntuami
  instance_type   = var.instance_type_micro
  #key_name        = aws_key_pair.key-pair.key_name
  key_name        = var.Privkey_name
  user_data       = base64encode(data.template_file.test.rendered)
  
  iam_instance_profile {
    arn = aws_iam_instance_profile.ssm_profile.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      throughput            = 125
      delete_on_termination = true
      encrypted             = true
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Team = "infra"
      Env  = "prod"
    }
  }
}