/* @Mithun Technologies
 Demo VPC varaibles file. Make sure you replace key_name value
 with your key name which  you have in given aws_region.
*/
variable "aws_region" {
  default = "eu-west-2"
}
variable "vpc_cidr" {
  default = "10.22.0.0/16"
}
variable "pub_subnets_cidr" {
  type    = list(string)
  default = ["10.22.1.0/24", "10.22.2.0/24", "10.22.3.0/24"]
}
variable "priv_subnets_cidr" {
  type    = list(string)
  default = ["10.22.11.0/24", "10.22.12.0/24", "10.22.13.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "ubuntuami" {
  default = "ami-0015a39e4b7c0966f"
}
variable "redhatami" {
  default = "ami-02354e95b39ca8dec"
}
variable "Pubkey_name" {
  default = "Bastion-Key"
}
variable "Privkey_name" {
  default = "londonkey"
}
variable "instance_type_micro" {
  default = "t2.micro"
}