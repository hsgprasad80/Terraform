variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type_micro" {
  default = "t2.micro"
}
variable "instance_type_medium" {
  default = "t2.medium"
}
variable "ubuntuami" {
  default = "ami-0d221091ef7082bcf"
}
variable "redhatami" {
  default = "ami-02354e95b39ca8dec"
}
variable "Privkey_name" {
  default = "private-key"
}
variable "number" {
  description = "Enter the number of nodes to be created"
  type        = string
}
