module "app" {
  source        = "./modules/service"
  is_https      = false
  http_port     = 3000
  use_next_auth = true
  use_dynamodb  = true
  dynamo_tables = ["User", "Participation"]
  providers = {
    aws.app        = aws.app
    aws.management = aws.management
  }
  label                   = var.label
  domainname              = var.domainname
  hostname                = "app.${var.domainname}"
  service_hostname        = "app.${var.domainname}"
  repository_tag          = var.repository_tag
  cluster_id              = module.infra.cluster_id
  vpc_id                  = module.infra.vpc_id
  private_subnets         = module.infra.private_subnets_id
  security_groups         = module.infra.security_groups_ids
  load_balancer           = module.infra.load_balancer
  lb_listener_arn         = module.infra.lb_listener
  task_execution_role_arn = module.infra.task_execution_role
  taskdef_filename        = "template/web-user.taskdef.json.tftpl" ## Todo will be node with self-signed
  depends_on              = [module.infra]
}
