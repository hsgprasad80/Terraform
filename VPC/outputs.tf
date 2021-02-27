output "elb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.Internet-facing-ALB.dns_name
}
output "Bastion_server" {
  value       = aws_instance.Bastion_server.*.public_ip
  description = "The public IP address of the bastion server"
}