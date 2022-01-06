variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "instance_type1" {
  default = "t2.micro"
}
variable "ubuntuami" {
  default = "ami-042e8287309f5df03"
}
variable "Privkey_name" {
  default = "private-key"
}
variable "number" {
  description = "Enter the number of nodes to be created"
  default     = "2"
}