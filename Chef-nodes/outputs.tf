# output values

output "private_ip" {
  value       = aws_instance.Chef-node.*.private_ip
  description = "The private IP address of the chef nodes"
}
output "public_dns" {
  value       = aws_instance.Chef-node.*.public_dns
  description = "The public dns of chef nodes"
}