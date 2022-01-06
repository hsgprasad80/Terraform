output "Nexus_Server" {
  value       = aws_instance.Nexus_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}