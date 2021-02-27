# creates a application load balancer 
resource "aws_lb" "Internet-facing-ALB" {
  name               = "Internet-facing-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_sg.id]
  subnets            = aws_subnet.Public_subnets.*.id

  enable_deletion_protection = false

  tags = {

    Environment = "My-test-ALB"
  }
}

#Create target group
resource "aws_lb_target_group" "TG1" {
  health_check {
    interval            = 5
    path                = "/"
    protocol            = "HTTP"
    timeout             = 4
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  name        = "my-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

/*
# registers instances to target group - note that i have registered instances from public subnet to check 
# whether load balancer passes the health check for instances.  
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.TG1.arn
  count            = length(aws_instance.Demo_Server)
  target_id        = aws_instance.Demo_Server[count.index].id
  port             = 80
}
*/

# ALB listner for HTTP
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Internet-facing-ALB.arn
  port              = "80"
  protocol          = "HTTP"
  #  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG1.arn
  }
}