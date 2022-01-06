# creates a application load balancer 
resource "aws_lb" "Internet-facing-ALB" {
  name               = "Internet-facing-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_sg.id]
  subnets            = aws_subnet.Public_subnets.*.id

  enable_deletion_protection = false

  tags = {

    Environment = "Internet-facing-ALB"
  }
}

#Create target group
resource "aws_lb_target_group" "Nbrown-TG" {
  health_check {
    interval            = 5
    path                = "/index.html"
    protocol            = "HTTP"
    timeout             = 4
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  name        = "Nbrown-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

# ALB listner for HTTP
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Internet-facing-ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Nbrown-TG.arn
  }
}

#register instances to target group
resource "aws_lb_target_group_attachment" "Demo-Nbrown" {
  target_group_arn = aws_lb_target_group.Nbrown-TG.arn
  count            = length(aws_instance.Node)
  target_id        = aws_instance.Node[count.index].id
  port             = 80
}