output "ec2key_name" {
  value = aws_key_pair.ec2key.key_name
}

output "ec2key_local_filename" {
  value = local_sensitive_file.pem_file.filename
}

output "githubdeploykey" {
  value     = aws_ssm_parameter.githubdeploykey.value
  sensitive = true
}
