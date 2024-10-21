data "aws_caller_identity" "current" {
  provider = aws.app
}

data "aws_region" "current" {
  provider = aws.app
}

locals {
  parameter_arn = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter"
}

resource "aws_lb_target_group" "service" {
  name        = replace("${var.label}.${var.service_hostname}", ".", "-")
  port        = var.use_https ? var.https_port : var.http_port
  protocol    = var.use_https ? "HTTPS" : "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = var.use_https ? "HTTPS" : "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-499"
  }
  tags     = var.cluster_tags
  provider = aws.app
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.lb_listener_arn

  condition {
    host_header {
      values = ["${var.hostname}", "${var.service_hostname}", "*.${var.service_hostname}"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
  tags     = var.cluster_tags
  provider = aws.app
}

resource "aws_lb_listener_certificate" "this" {
  count           = var.use_https ? 1 : 0
  listener_arn    = var.lb_listener_arn
  certificate_arn = var.cert_arn
  provider        = aws.app
}

resource "aws_route53_record" "service_hostname" {
  zone_id = var.zone_id
  name    = var.service_hostname
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
  provider        = aws.management
  allow_overwrite = true
}

resource "aws_route53_record" "hostname" {
  zone_id = var.zone_id
  name    = var.hostname
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
  provider        = aws.management
  allow_overwrite = true
}

resource "aws_ecs_task_definition" "service" {
  family                   = replace("${var.service_hostname}", ".", "-")
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.task_execution_role_arn
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  container_definitions = templatefile(
    "${path.module}/${var.taskdef_filename}", {
      name : replace("${var.service_hostname}-${var.label}", ".", "-"),
      image : "${var.repository_url}:${var.repository_tag}",
      parameter_arn : "${local.parameter_arn}/${var.domainname}/${var.label}",
      p_arn : "${local.parameter_arn}",
      port: var.use_https ? var.https_port : var.http_port
    }
  )
  tags     = var.cluster_tags
  provider = aws.app
}

resource "aws_ecs_service" "this" {
  name                 = replace(var.service_hostname, ".", "-")
  cluster              = var.cluster_id
  task_definition      = aws_ecs_task_definition.service.arn
  desired_count        = 1
  launch_type          = "FARGATE"
  force_new_deployment = var.force_deploy

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.security_groups
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = replace("${var.service_hostname}-${var.label}", ".", "-")
    container_port   = var.use_https ? var.https_port : var.http_port
  }
  tags     = var.cluster_tags
  provider = aws.app

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }
}
