data "aws_ami" "base_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  provider = aws.app
}
resource "aws_instance" "ec2vm" {
  provider = aws.app
  
  associate_public_ip_address = true

  ami           = data.aws_ami.base_ami.image_id
  instance_type = var.instance_type
  user_data     = file("${path.module}/template/ec2.userdata.sh")
  tags = merge(
    var.ec2_tags,
    { "Name" = "${var.label}" }
  )
  subnet_id            = var.subnet_id
  key_name             = var.ec2key_name
  security_groups      = var.security_groups_ids
  iam_instance_profile = aws_iam_instance_profile.ec2ssm-profile.name
  
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}
resource "aws_iam_instance_profile" "ec2ssm-profile" {
  provider = aws.app

  name = "${var.label}-ec2vm-sssm-profile"
  role = aws_iam_role.ec2ssm-role.name
}
resource "aws_iam_role" "ec2ssm-role" {
  provider = aws.app

  name               = "${var.label}-ssm-role"
  description        = "The role for the developer resources EC2"
  assume_role_policy = file("${path.module}/template/ec2.trustpolicy.json") 
  tags = merge(var.ec2_tags)
}
resource "aws_iam_role_policy_attachment" "resource-ssm-policy" {
  provider = aws.app

  role       = aws_iam_role.ec2ssm-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_ssm_document" "githubkey_conf" {
  provider = aws.app

  document_type = "Command"
  name          = "${var.label}-github"
  content = file("${path.module}/template/githubssh.ssm.json") 
}
resource "aws_ssm_association" "ec2_githubkey" {
  provider = aws.app

  name             = "${var.label}-github"
  document_version = aws_ssm_document.githubkey_conf.default_version
  parameters = {
    "cmd" : templatefile("${path.module}/template/githubssh.setup.tftpl", {
      "githubkey": var.githubdeploykey
    }),
  }
  targets {
    key    = "InstanceIds"
    values = [aws_instance.ec2vm.id]
  }

}