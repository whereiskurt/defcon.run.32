
resource "aws_ecr_repository" "repo" {
  name     = var.name
  provider = aws.app
  tags     = var.ecr_tags
  force_delete = true
  
  # encryption_configuration {
  #   encryption_type = "KMS"
  # }

  # image_tag_mutability = "IMMUTABLE"
  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}
