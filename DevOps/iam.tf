# creates a role
resource "aws_iam_role" "ec2_S3_access_role" {
  name = "ec2_S3_access_role"
  assume_role_policy = "${file("S3-access-role.json")}"
}
# create a policy
resource "aws_iam_policy" "S3_policy" {
  name = "S3_policy"
  policy = "${file("S3-policy.json")}"
 }
# Attach policy to the role
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_S3_access_role.name}"]
  policy_arn = "${aws_iam_policy.S3_policy.arn}"
}
# which must be used to tag the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_S3_access_role.name
}

# Below code creates CodeDeploy role requried to be used in Deployment group.

# create a CodeDeploy policy
resource "aws_iam_policy" "CodeDeploy_policy" {
  name = "CodeDeploy_policy"
  policy = "${file("CodeDeploy_policy.json")}"
 }
# creates a CodeDeploy role
resource "aws_iam_role" "CodeDeploy_role" {
  name = "CodeDeploy_role"
  assume_role_policy = "${file("CodeDeploy_role.json")}"
}
# Attach CodeDeploy policy to the CodeDeploy role
resource "aws_iam_policy_attachment" "CodeDeploy-attach" {
  name       = "CodeDeploy-attachment"
  roles      = ["${aws_iam_role.CodeDeploy_role.name}"]
  policy_arn = "${aws_iam_policy.CodeDeploy_policy.arn}"
}
