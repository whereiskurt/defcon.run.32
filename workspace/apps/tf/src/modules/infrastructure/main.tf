locals {
  tags = merge(
    var.global_tags,
    { Terraform   = "true",
      Environment = var.environment,
      Deployment  = var.deployment
    }
  )
}

module "network" {
  network_tags         = local.tags
  label                = var.label
  source               = "./modules/network"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.azs
  domainname           = var.domainname

  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
  enable_lb_delete_protection = var.enable_lb_delete_protection
}

module "ecs-cluster" {
  domainname = var.domainname
  source     = "./modules/ecs-cluster"
  providers = {
    aws.app = aws.app
  }
}

module "secrets" {
  source          = "./modules/secrets"
  domainname      = var.domainname
  secret_tags     = local.tags
  label           = var.label
  githubdeploykey = var.githubdeploykey
  providers = {
    aws.app = aws.app
  }
}

module "rds" {
  count      = var.with_RDS ? 1 : 0
  source     = "./modules/rds"
  domainname = var.domainname
  label      = var.label
  providers = {
    aws.app = aws.app
  }
  vpc_id          = module.network.vpc_id
  security_groups = module.network.security_groups_ids
  private_subnets = module.network.private_subnets_id
  db_name         = var.db_name
  db_password     = var.db_password
  db_username     = var.db_username
}

module "s3-fronted" {
  count           = var.with_S3 ? 1 : 0
  source          = "./modules/s3-fronted"
  bucket_tags     = local.tags
  label           = var.label
  domainname      = var.domainname
  bucket_name     = var.bucket_name
  certificate_arn = module.network.certificate.arn
  bucket_cnames   = var.bucket_cnames
  zone_id         = module.network.zone_id
  role_arn        = module.ecs-cluster.task_execution_role
  providers = {
    aws.app        = aws.app,
    aws.management = aws.management
  }
}
