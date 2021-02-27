variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default     = "us-east-1"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-0915bcb5fa77e4892"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "Privkey_name" {
  default = "private-key"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "/home/core/.ssh/id_rsa.pub"
}

variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default     = "install-docker.sh"
}