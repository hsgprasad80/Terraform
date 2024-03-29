# output values

output "private_ip" {
  value       = aws_instance.Chef-workstation.*.private_ip
  description = "The private IP address of the chef nodes"
}
output "public_dns" {
  value       = aws_instance.Chef-workstation.*.public_dns
  description = "The public dns of chef nodes"
}
output "aws_vpc_id" {
  value = data.aws_vpc.selected.id
}
output "aws_security_group_id" {
  value = data.aws_security_group.my_sg.id
}
