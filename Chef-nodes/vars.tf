/* @Mithun Technologies
 Chef nodes varaibles file. Make sure you replace key_name value
 with your key name which  you have in given aws_region.
*/
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
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
