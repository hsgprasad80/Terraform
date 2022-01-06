# instance role with ssm permission for ec2 
data "aws_iam_policy_document" "assume_ec2" {
    statement {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
       type        = "Service"
       identifiers = ["ec2.amazonaws.com"]  
      }
    }
}
resource "aws_iam_role" "ssm_role" {
    name                     = "aws_ssm_role"
    description              = "Role that instances runs as"
    assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}

resource "aws_iam_role_policy_attachment" "demossm" {
    role = aws_iam_role.ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name  = "instance-asg-profile"
  role  = aws_iam_role.ssm_role.name  
}