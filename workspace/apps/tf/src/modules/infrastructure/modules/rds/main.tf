locals {
  tags = merge(
    var.global_tags,
    { Terraform   = "true",
      Environment = var.environment,
      Deployment  = var.deployment
    }
  )
}

resource "aws_db_subnet_group" "postgres" {
  name       = "${var.label}.strapi"
  subnet_ids = var.private_subnets
  provider   = aws.app
}

resource "aws_security_group" "postgres" {
  name        = "${var.label}.postgres"
  description = "Strapi"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.security_groups # Allow access from another security group
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags     = local.tags
  provider = aws.app
}

resource "aws_db_instance" "postgres" {
  identifier              = replace("strapi-${var.label}-${var.domainname}", ".", "-")
  storage_type            = "gp2"
  engine                  = "postgres"
  allocated_storage       = 20
  engine_version          = "16.2"
  instance_class          = "db.t4g.small"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.postgres.name
  vpc_security_group_ids  = [aws_security_group.postgres.id]
  backup_retention_period = 0
  skip_final_snapshot     = true
  tags                    = local.tags
  provider                = aws.app
  parameter_group_name    = aws_db_parameter_group.ssl_disable.name
}

resource "aws_db_parameter_group" "ssl_disable" {
  name        = "disable-ssl"
  family      = "postgres16" # Change according to your PostgreSQL version
  description = "Custom parameter group for my RDS instance"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
  provider = aws.app
}

resource "aws_ssm_parameter" "db_client" {
  type     = "String"
  name     = "/${var.domainname}/${var.label}/postgres/db_client"
  value    = "postgres"
  provider = aws.app
}
resource "aws_ssm_parameter" "db_host" {
  type     = "String"
  name     = "/${var.domainname}/${var.label}/postgres/db_host"
  value    = aws_db_instance.postgres.address
  provider = aws.app
}
resource "aws_ssm_parameter" "db_port" {
  type     = "String"
  name     = "/${var.domainname}/${var.label}/postgres/db_port"
  value    = aws_db_instance.postgres.port
  provider = aws.app
}
resource "aws_ssm_parameter" "db_name" {
  type     = "String"
  name     = "/${var.domainname}/${var.label}/postgres/db_name"
  value    = var.db_name
  provider = aws.app
}
resource "aws_ssm_parameter" "db_username" {
  type     = "String"
  name     = "/${var.domainname}/${var.label}/postgres/db_username"
  value    = var.db_username
  provider = aws.app
}
resource "aws_ssm_parameter" "db_password" {
  type     = "SecureString"
  name     = "/${var.domainname}/${var.label}/postgres/db_password"
  value    = var.db_password
  provider = aws.app
}
