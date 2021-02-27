variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ubuntuami" {
  default = "ami-03d315ad33b9d49c4"
}
variable "redhatami" {
  default = "ami-047a51fa27710816e"
}
variable "Privkey_name" {
  default = "private-key"
}
variable "number" {
  description = "Enter the number of nodes to be created"
  type        = string
}
