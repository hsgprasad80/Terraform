variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "11.0.148.0/22"
}
variable "pub_subnets_cidr" {
  type    = list(string)
  default = ["11.0.148.0/24", "11.0.149.0/24", "11.0.150.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "instance_type" {
  default = "t2.micro"
}
variable "redhatami" {
  default = "ami-0915bcb5fa77e4892"
}
variable "Privkey_name" {
  default = "private-key"
}
variable "number" {
  description = "Enter the number of nodes to be created"
  type        = string
}