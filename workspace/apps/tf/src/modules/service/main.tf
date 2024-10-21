locals {
  tags = merge(
    var.global_tags,
    { Terraform   = "true",
      Environment = var.environment,
      Deployment  = var.deployment
    }
  )
}

module "ecr" {
  ecr_tags = local.tags
  label    = var.label
  source   = "./modules/ecr"
  name     = "${var.label}.${var.service_hostname}"
  providers = {
    aws.app = aws.app
  }
}

data "aws_route53_zone" "defcon" {
  provider = aws.management
  name     = var.domainname
}

module "certs" {
  cert_tags        = local.tags
  label            = var.label
  source           = "./modules/certs"
  hostname         = var.hostname
  service_hostname = var.service_hostname
  domainname       = var.domainname
  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
}

module "ecs-service" {
  cluster_tags = local.tags
  label        = var.label
  source       = "./modules/ecs"
  providers = {
    aws.app        = aws.app,
    aws.management = aws.management
  }
  use_https               = var.is_https
  http_port               = var.http_port
  https_port              = var.https_port
  zone_id                 = data.aws_route53_zone.defcon.zone_id
  cert_arn                = module.certs.certificate_arn
  lb_listener_arn         = var.lb_listener_arn
  repository_url          = module.ecr.repository_url
  repository_tag          = var.repository_tag
  hostname                = var.hostname
  force_deploy            = var.force_deploy
  cluster_id              = var.cluster_id
  vpc_id                  = var.vpc_id
  private_subnets         = var.private_subnets
  security_groups         = var.security_groups
  lb_zone_id              = var.load_balancer.zone_id
  lb_dns_name             = var.load_balancer.dns_name
  task_execution_role_arn = var.task_execution_role_arn
  taskdef_filename        = var.taskdef_filename
  service_hostname        = var.service_hostname
  domainname              = var.domainname
  depends_on              = [module.certs]
}

module "next-auth-db" { ##TODO: Rename KPHKPHKPH
  count     = var.use_next_auth ? 1 : 0
  auth_tags = local.tags
  label     = var.label
  source    = "./modules/next-auth-db"
  providers = {
    aws.app = aws.app
  }
  service_hostname = var.service_hostname
}

module "dynamodb" { ##TODO: Rename KPHKPHKPH
  count     = var.use_dynamodb ? 1 : 0

  auth_tags = local.tags
  label     = var.label
  source    = "./modules/dynamodb"
  providers = {
    aws.app = aws.app
  }
  dynamo_tables = var.dynamo_tables
  service_hostname = var.service_hostname
}