resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2key" {
  key_name   = "${var.label}-ec2key"
  public_key = tls_private_key.pk.public_key_openssh
  provider = aws.app
}

resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("output/${aws_key_pair.ec2key.key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.pk.private_key_pem
}

resource "aws_ssm_parameter" "githubdeploykey" {
  name  = "/${var.domainname}/github/deploykey"
  type  = "SecureString"
  value = var.githubdeploykey
  provider = aws.app
}