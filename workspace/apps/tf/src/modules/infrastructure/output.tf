output "load_balancer" {
  value = module.network.lb_public
}
output "task_execution_role" {
  value = module.ecs-cluster.task_execution_role
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnets_id" {
  value = module.network.private_subnets_id
}

output "public_subnets_id" {
  value = module.network.public_subnets_id
}
output "security_groups_ids" {
  value = module.network.security_groups_ids
}

output "cluster_id" {
  value = module.ecs-cluster.cluster_id
}

output "lb_listener" {
  value = module.network.lb_listener
}

output "ec2key_name" {
  value = "${module.secrets.ec2key_name}"
}

output "ec2key_local_filename" {
  value = "${module.secrets.ec2key_local_filename}"
}

output "githubdeploykey" {
  value = "${module.secrets.githubdeploykey}"
  sensitive = true
}

output "db_name" {
  value = var.db_name
}
output "db_username" {
  value = var.db_username
}
output "db_password" {
  value = var.db_password
}
output "bucketname" {
  value = module.s3-fronted[0].bucketname
}