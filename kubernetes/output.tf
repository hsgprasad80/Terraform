output "master_private_ip" {
  value       = aws_instance.Kube-master.private_ip
  description = "The private IP address of the chef nodes"
}
output "master_public_dns" {
  value       = aws_instance.Kube-master.public_dns
  description = "The public dns of chef nodes"
}
/*
output "worker_private_ip" {
  value       = aws_instance.Kube-worker.*.private_ip
  description = "The private IP address of the chef nodes"
}
output "worker_public_dns" {
  value       = aws_instance.Kube-worker.*.public_dns
  description = "The public dns of chef nodes"
}
*/
output "aws_vpc_id" {
  value = data.aws_vpc.selected.id
}
output "aws_security_group_id" {
  value = data.aws_security_group.my_sg.id
}
