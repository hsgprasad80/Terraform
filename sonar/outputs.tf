output "SonarQube_Server" {
  value       = aws_instance.SonarQube_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}