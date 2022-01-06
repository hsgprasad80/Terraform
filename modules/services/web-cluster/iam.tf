resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

resource "aws_iam_policy" "cloudwatch_read_only" {  
  name = "cloudwatch_read_only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "cloudwatch_full_acces" {
    name = "cloudwatch_full_access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect = "Allow"
    actions = [ "Cloudwatch:*" ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy_attachment" "neo_cloudwatch_full_access" {
  count = var.give_neo_cloudwatch_full_acess ? 1 : 0
  name = "neo_cloudwatch_full_access"
  users  = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_full_acces.arn
}

resource "aws_iam_policy_attachment" "neo_cloudwatch_read_only" {
  count = var.give_neo_cloudwatch_full_acess ? 1 : 0
  name = "neo_cloudwatch_read_only"
  users  = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}