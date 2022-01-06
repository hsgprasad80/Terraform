output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = aws_lb.example.dns_name
}
output "asg_name" {
  description = "Name of the auto scaling group that can be used in calling module"
  value = aws_autoscaling_group.example.name
}
output "all_users" {
  value = aws_iam_user.example
}
output "all_users1" {
  value = values(aws_iam_user.example)[*].arn
}
