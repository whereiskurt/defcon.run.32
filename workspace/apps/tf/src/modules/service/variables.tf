variable "deployment" {
  type        = string
  description = "Deployment tag applied to all resources"
  default     = "20230428.manual"
}

variable "environment" {
  type        = string
  description = "Environment tag applied to all resources"
  default     = "public"
}

variable "label" {
  type        = string
  description = "Release label tag applied to all resources"
}

variable "global_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default     = {}
}

variable "domainname" {
  type        = string
  description = "Domain name like defcon.run"
}
variable "hostname" {
  type        = string
  description = "Hostname like app.defcon.run"
}
variable "service_hostname" {
  description = "Full release name like rabbit.add.defcon.run"
}

variable "load_balancer" {
  description = "Public LB"
}

variable "task_execution_role_arn" {
  type = string
  description = "Cluster role to run ECS task"
}

variable "taskdef_filename" {
  type = string
  description = "Template file name to build task definition from."
}

variable "vpc_id" {
  type = string
  description = ""
}

variable "cluster_id" {
  description = ""
}

variable "force_deploy" {
  description = ""
  default = true
}

variable "private_subnets" {
  description = ""
}
variable "security_groups" {
  description = ""
}

variable "repository_tag" {
  description = ""
}

variable "lb_listener_arn" {
  description = ""
}

variable "is_https" {
  default = true
}
variable "https_port" {
  description = "Port for HTTPS"
  type        = number
  default     = 443
}

variable "http_port" {
  description = "Port for HTTP"
  type        = number
  default     = 8080
}

variable "use_next_auth" {
  type = bool
}
variable "use_dynamodb" {
  type = bool
}
variable "dynamo_tables" {
  type = list(string)
  default = [ ]
}