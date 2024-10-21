output "bucketname" {
  # value = aws_iam_user.s3-bucketuser.name
  value = aws_s3_bucket.asset-bucket.bucket
}