data "aws_availability_zones" "available" {   
     }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>3.0"

  name                    = "demo-vpc"
  cidr                    = var.vpc_cidr_block
  azs                     = data.aws_availability_zones.available.names
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  map_public_ip_on_launch = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  tags = {
      Owner   = "ops"
      Created = "terraform"
      Name    = "demo-vpc"
  } 
}

resource "aws_default_network_acl" "default" {
    default_network_acl_id = module.vpc.default_network_acl_id
    ingress {
      protocol   = -1
      rule_no    = 2
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
    ingress {
      protocol   = -1
      rule_no    = 2
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

    tags = {
        Name = "demo-vpc-defaultacl"
    }

    lifecycle {
      ignore_changes = [subnet_ids]
    }
}