#provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "C:\\Users\new.user-PC\\.aws\\credentials"
  //*shared_credentials_file = "~/.aws/credentials" for linux
  profile = "guru"
}

# Name of the instance is being fetched from SSM parameter store
data "aws_ssm_parameter" "db_insatnce" {  
  name            = "admin-demodb-password" # our SSM parameter's name
  with_decryption = true # defaults to true, but just to be explicit...
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "rds-private-subnet-group"
  subnet_ids = ["subnet-02ba0f3df391dd1fc","subnet-0a52473b6e9bfe5e2"]
}

resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = "vpc-08401d41ff22168c2"
}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "aws_security_group.rds-sg.id"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Creates MySQL instance
resource "aws_db_instance" "demodb" {
  identifier              = "database-1"
  db_subnet_group_name    = "aws_db_subnet_group.rds-private-subnet.name" 
  engine                  = "mysql"
  engine_version          = "5.7.19"
  instance_class          = "db.t2.large"
  allocated_storage       = 5
  storage_encrypted       = true
  storage_type            = "gp2"
  publicly_accessible     = false

  name                    = "demodb"
  username                = "admin"
  password                = data.aws_ssm_parameter.db_insatnce.value
  port                    = "3306"

  vpc_security_group_ids  = ["${aws_security_group.rds-sg.id}"]

  multi_az                = false
  maintenance_window      = "Sun:00:00-Sun:02:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  iam_database_authentication_enabled = false
  
  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "0"
  #monitoring_role_name   = "MyRDSMonitoringRole"
  #create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"
  skip_final_snapshot       = true
  
  # Database Deletion Protection
  deletion_protection = false
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}