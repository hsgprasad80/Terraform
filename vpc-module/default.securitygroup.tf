resource "aws_security_group" "sg-ssh" {
  vpc_id                 = module.vpc.vpc_id
  revoke_rules_on_delete = true

  name        =   "open connection to ssh"
  description =   "Allow ssh for self"

  ingress  {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [var.vpc_cidr_block, var.default_ips]
  }

  egress  {
      from_port =  22
      to_port   =  22
      protocol  = "tcp"
      cidr_blocks = [var.vpc_cidr_block, var.default_ips]
  }

  tags = {
      Name  = "default connection"
  }
}
