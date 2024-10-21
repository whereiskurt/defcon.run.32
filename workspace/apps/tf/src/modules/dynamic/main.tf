locals {
  tags = merge(
    var.ec2_tags,
    { Terraform   = "true",
      Environment = var.environment,
      Deployment  = var.deployment
    }
  )
}

module "vm-dev" {
  source              = "./modules/ec2"
  region              = var.region
  label               = "${var.label}-dev"
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_groups_ids = var.security_groups_ids
  ec2key_name         = var.ec2key_name
  ec2_tags            = local.tags
  githubdeploykey     = var.githubdeploykey

  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }

}

