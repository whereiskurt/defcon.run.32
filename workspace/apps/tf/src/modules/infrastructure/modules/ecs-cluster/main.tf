resource "aws_ecs_cluster" "cluster" {
  name     = replace("${var.domainname}", ".", "-")
  provider = aws.app
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = file("${path.module}/template/ecs.trustpolicy.json")
  provider           = aws.app
}

resource "aws_iam_role_policy_attachment" "ecs_task_ecspolicy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  provider   = aws.app
}
resource "aws_iam_role_policy_attachment" "ecs_task_logpolicy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccessV2"
  provider   = aws.app
}

resource "aws_iam_role_policy" "ecs_task_ssm_full_access" {
  name   = "ecs_task_ssm_full_access"
  role   = aws_iam_role.ecs_task_execution_role.id
  provider = aws.app

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:*", "s3:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}