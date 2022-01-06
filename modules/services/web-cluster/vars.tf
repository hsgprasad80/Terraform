variable "aws_region" {
  default = "us-east-1"
}
variable "ami" {
  description = "the AMI to run in the cluster"
  default     = "ami-042e8287309f5df03"
  type        = string 
}
variable "server_port" {
  description = "The port server will use for http request"
  type        = number
  default     = "8080"
}
variable "server_text" {
  description = "The text webserver should return"
  type = string
  default = "Hello, world"
}
variable "cluster_name" {
  description = "Name of the cluster"
  type = string
}
variable "db_remote_state_bucket" {
  description = "Name of the S3 bucket"
  type = string
}
variable "web_remote_state_lock" {
  description = "Name of the Dynamodb table"
  type = string
}
variable "web_remote_state_key" {
  description = "The path for the web's remote state in s3"
  type = string
}
variable "db_remote_state_key" {
  description = "The path for the database's remote state in s3"
  type = string
}
variable "instance_type" {
  description = "set the type of instance to be launched"
  type = string
}
variable "max_size" {
  description = "Set the max number of instances under ASG"
  type = string
}
variable "min_size" {
  description = "Set the max number of instances under ASG"
  type = string
}
variable "desired_size" {
  description = "Set the max number of instances under ASG"
  type = string
}
variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}
variable "give_neo_cloudwatch_full_acess" {
  description = "If ture neo will get cloudwatch full access"
  type        = bool
}
variable "user_names" {
  description = "Names of the users to be created"
  type = list(string)
  default = ["Shruti", "Guru", "Thejas"]
}
variable "custom_tags" {
  description = "custom tags to set on the instances in the ASG"
  type = map(string)
  default = {}
}