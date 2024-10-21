provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "defcon-run-20240420-tf-state"
}

resource "aws_kms_key" "dynamo-key" {
  description         = "KMS key for all TF"
  enable_key_rotation = true
}

resource "aws_dynamodb_table" "defcon-run-20240420-tf-lock" {
  name           = "defcon-run-20240420-tf-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamo-key.arn
  }
  point_in_time_recovery {
    enabled = true
  }
}
