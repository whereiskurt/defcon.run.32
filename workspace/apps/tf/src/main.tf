module "infra" {
  source = "./modules/infrastructure"
  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
  label                = var.label
  domainname           = var.domainname
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  githubdeploykey      = var.githubdeploykey
  with_RDS             = true
  db_name              = var.STRAPI_DB_NAME
  db_password          = var.STRAPI_DB_PASSWORD
  db_username          = var.STRAPI_DB_USERNAME
  with_S3              = true
  bucket_name          = replace("assets-cms-${var.domainname}-20240512", ".", "-")
  bucket_cnames        = ["assets.cms.${var.domainname}"]
}

module "dev" {
  count               = 0
  source              = "./modules/dynamic"
  label               = var.label
  instance_type       = "t3.xlarge"
  region              = "us-east-1"
  hostname            = "dev1.rabbit.${var.domainname}"
  subnet_id           = module.infra.public_subnets_id[0]
  ec2key_name         = module.infra.ec2key_name
  security_groups_ids = module.infra.security_groups_ids
  githubdeploykey     = module.infra.githubdeploykey
  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
  depends_on = [module.infra]
}


