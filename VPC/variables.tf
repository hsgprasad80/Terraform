/* @Mithun Technologies
 Demo VPC varaibles file. Make sure you replace key_name value
 with your key name which  you have in given aws_region.
*/
variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "11.0.148.0/22"
}
variable "pub_subnets_cidr" {
  type    = list(string)
  default = ["11.0.148.0/24", "11.0.149.0/24"]
}
variable "priv_subnets_cidr" {
  type    = list(string)
  default = ["11.0.150.0/24", "11.0.151.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "ubuntuami" {
  default = "ami-0d221091ef7082bcf"
}
variable "redhatami" {
  default = "ami-02354e95b39ca8dec"
}
variable "Pubkey_name" {
  default = "Bastion-Key"
}
variable "Privkey_name" {
  default = "private-key"
}
variable "instance_type_micro" {
  default = "t2.micro"
}