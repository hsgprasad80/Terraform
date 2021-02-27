output "Tomcat_Server" {
  value       = aws_instance.Tomcat_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}
output "SonarQube_Server" {
  value       = aws_instance.SonarQube_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}
output "Nexus_Server" {
  value       = aws_instance.Nexus_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}
output "Jenkins_Server" {
  value       = aws_instance.Jenkins_Server.*.public_ip
  description = "The private IP address of the chef nodes"
}