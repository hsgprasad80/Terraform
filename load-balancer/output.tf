output "elb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.Internet-facing-ALB.dns_name
}