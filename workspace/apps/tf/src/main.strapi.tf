module "strapi" {
  source   = "./modules/service"
  is_https = false
  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
  label                   = var.label
  domainname              = var.domainname
  hostname                = "cms.${var.domainname}"
  service_hostname        = "strapi.cms.${var.domainname}"
  repository_tag          = var.repository_tag
  cluster_id              = module.infra.cluster_id
  vpc_id                  = module.infra.vpc_id
  private_subnets         = module.infra.private_subnets_id
  security_groups         = module.infra.security_groups_ids
  load_balancer           = module.infra.load_balancer
  lb_listener_arn         = module.infra.lb_listener
  task_execution_role_arn = module.infra.task_execution_role
  taskdef_filename        = "template/strapi.taskdef.json.tftpl"
  depends_on              = [module.infra]
  use_next_auth           = false
  use_dynamodb            = false
}

data "aws_caller_identity" "current" {
  provider = aws.app
}

data "aws_region" "current" {
  provider = aws.app
}

resource "aws_ssm_parameter" "smtp_host" {
  name     = "/${var.domainname}/${var.label}/strapi/smtp/host"
  type     = "String"
  value    = "email.${var.region}.amazonaws.com"
  provider = aws.app
}
resource "aws_ssm_parameter" "region" {
  name     = "/${var.domainname}/${var.label}/strapi/s3/region"
  type     = "String"
  value    = var.region
  provider = aws.app
}
resource "aws_ssm_parameter" "node_env" {
  name     = "/${var.domainname}/${var.label}/strapi/node_env"
  type     = "String"
  value    = "production"
  provider = aws.app
}

##########################################
data "aws_ssm_parameter" "db_client" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_client"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_client" {
  name     = "/${var.domainname}/${var.label}/strapi/db/client"
  type     = "String"
  value    = data.aws_ssm_parameter.db_client.value
  provider = aws.app
}

data "aws_ssm_parameter" "db_port" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_port"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_port" {
  name     = "/${var.domainname}/${var.label}/strapi/db/port"
  type     = "String"
  value    = data.aws_ssm_parameter.db_port.value
  provider = aws.app
}

data "aws_ssm_parameter" "db_name" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_name"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_name" {
  name     = "/${var.domainname}/${var.label}/strapi/db/name"
  type     = "String"
  value    = data.aws_ssm_parameter.db_name.value
  provider = aws.app
}

data "aws_ssm_parameter" "db_username" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_username"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_username" {
  name     = "/${var.domainname}/${var.label}/strapi/db/username"
  type     = "String"
  value    = data.aws_ssm_parameter.db_username.value
  provider = aws.app
}

data "aws_ssm_parameter" "db_password" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_password"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_password" {
  name     = "/${var.domainname}/${var.label}/strapi/db/password"
  type     = "SecureString"
  value    = data.aws_ssm_parameter.db_password.value
  provider = aws.app
}

data "aws_ssm_parameter" "db_host" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/postgres/db_host"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "db_host" {
  name     = "/${var.domainname}/${var.label}/strapi/db/host"
  type     = "String"
  value    = data.aws_ssm_parameter.db_host.value
  provider = aws.app
}

data "aws_ssm_parameter" "access_key" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/s3/${module.infra.bucketname}/access_key"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "access_key" {
  name     = "/${var.domainname}/${var.label}/strapi/s3/access_key"
  type     = "String"
  value    = data.aws_ssm_parameter.access_key.value
  provider = aws.app
}

data "aws_ssm_parameter" "secret_key" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/s3/${module.infra.bucketname}/secret_key"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "secret_key" {
  name     = "/${var.domainname}/${var.label}/strapi/s3/secret_key"
  type     = "SecureString"
  value    = data.aws_ssm_parameter.secret_key.value
  provider = aws.app
}

data "aws_ssm_parameter" "bucketname" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/s3/bucketname"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "bucketname" {
  name     = "/${var.domainname}/${var.label}/strapi/s3/bucketname"
  type     = "String"
  value    = data.aws_ssm_parameter.bucketname.value
  provider = aws.app
}

data "aws_ssm_parameter" "cdnurl" {
  provider   = aws.app
  name       = "/${var.domainname}/${var.label}/s3/cdnurl"
  depends_on = [module.infra]
}
resource "aws_ssm_parameter" "cdnurl" {
  name     = "/${var.domainname}/${var.label}/strapi/s3/cdnurl"
  type     = "SecureString"
  value    = data.aws_ssm_parameter.cdnurl.value
  provider = aws.app
}

data "aws_ssm_parameter" "smtp_user" {
  provider = aws.app
  name     = "/defcon/prod/smtp.user"
}
resource "aws_ssm_parameter" "smtp_user" {
  name     = "/${var.domainname}/${var.label}/strapi/smtp/user"
  type     = "String"
  value    = data.aws_ssm_parameter.smtp_user.value
  provider = aws.app
}

data "aws_ssm_parameter" "smtp_password" {
  provider = aws.app
  name     = "/defcon/prod/smtp.password"
}
resource "aws_ssm_parameter" "smtp_password" {
  name     = "/${var.domainname}/${var.label}/strapi/smtp/password"
  type     = "String"
  value    = data.aws_ssm_parameter.smtp_password.value
  provider = aws.app
}

provider "random" {}

resource "random_id" "app_keys" {
  byte_length = 32
  count       = 4
}
resource "aws_ssm_parameter" "app_keys" {
  name     = "/${var.domainname}/${var.label}/strapi/secrets/app_keys"
  type     = "SecureString"
  value    = join(",", [for id in random_id.app_keys[*] : base64encode(id.b64_std)])
  provider = aws.app
}

resource "random_id" "jwt_secret" {
  byte_length = 32
}
resource "aws_ssm_parameter" "jwt_secret" {
  name     = "/${var.domainname}/${var.label}/strapi/secrets/jwt_secret"
  type     = "SecureString"
  value    = base64encode(random_id.jwt_secret.b64_std)
  provider = aws.app
}

resource "random_id" "api_token_salt" {
  byte_length = 32
}
resource "aws_ssm_parameter" "api_token_salt" {
  name     = "/${var.domainname}/${var.label}/strapi/secrets/api_token_salt"
  type     = "SecureString"
  value    = base64encode(random_id.api_token_salt.b64_std)
  provider = aws.app
}

resource "random_id" "admin_jwt_secret" {
  byte_length = 32
}
resource "aws_ssm_parameter" "admin_jwt_secret" {
  name     = "/${var.domainname}/${var.label}/strapi/secrets/admin_jwt_secret"
  type     = "SecureString"
  value    = base64encode(random_id.admin_jwt_secret.b64_std)
  provider = aws.app
}

resource "random_id" "transfer_token_salt" {
  byte_length = 32
}
resource "aws_ssm_parameter" "transfer_token_salt" {
  name     = "/${var.domainname}/${var.label}/strapi/secrets/transfer_token_salt"
  type     = "SecureString"
  value    = base64encode(random_id.transfer_token_salt.b64_std)
  provider = aws.app
}
