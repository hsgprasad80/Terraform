output "Tomcat_Server" {
  value       = aws_instance.Tomcat_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}