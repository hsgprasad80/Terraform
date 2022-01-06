variable "aws_region" {
  default = "eu-west-2"
}

variable "vpc_cidr_block" {
  type = string
}
variable "public_subnets" {
  type    = list(string)
  default = []
}
variable "private_subnets" {
  type    = list(string)
  default = []
}
variable "default_ips" {
  type    = string
}

