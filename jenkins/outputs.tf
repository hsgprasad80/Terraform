output "Jenkins_Server" {
  value       = aws_instance.Jenkins_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}