data "aws_caller_identity" "current" {
  provider = aws.app
}

data "aws_region" "current" {
  provider = aws.app
}

resource "aws_iam_user" "this" {
  name     = "dynamodb.${var.label}.${var.service_hostname}"
  provider = aws.app
}

resource "aws_iam_access_key" "this" {
  user     = aws_iam_user.this.name
  provider = aws.app
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
  provider   = aws.app
}

locals {
  dyna_arn = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"

  dyna_resources = flatten([
    for table_name in var.dynamo_tables : [
      "${local.dyna_arn}:table/${table_name}",
      "${local.dyna_arn}:table/${table_name}/index/*"
    ]
  ])
}

resource "aws_iam_policy" "this" {
  name     = "dynamodb-${var.label}-${replace(var.service_hostname, ".", "-")}"
  provider = aws.app

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "DynamoDBAccess",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Batch*",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Get*",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:Update*",
          "dynamodb:Create*"
        ],
        "Resource" : local.dyna_resources
      }
    ]
  })
}

resource "aws_ssm_parameter" "access_key" {
  name     = "/${var.service_hostname}/${var.label}/dynamodb/access_key"
  type     = "String"
  value    = aws_iam_access_key.this.id
  provider = aws.app
}
resource "aws_ssm_parameter" "secret_key" {
  name     = "/${var.service_hostname}/${var.label}/dynamodb/secret_key"
  type     = "SecureString"
  value    = aws_iam_access_key.this.secret
  provider = aws.app
}
