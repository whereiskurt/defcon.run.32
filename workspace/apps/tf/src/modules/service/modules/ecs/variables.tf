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
  description = "Label tag applied to all resources"
  default     = "rabbit"
}

variable "cluster_tags" {
  description = ""
  type        = map(string)
  default     = {}
}

variable "repository_url" {
  type        = string
  description = ""
}
variable "repository_tag" {
  type        = string
  description = ""
}

variable "task_execution_role_arn" {
  description = "Cluster role to run ECS task"
}

variable "lb_listener_arn" {
  description = ""
}

variable "lb_dns_name" {
  description = ""
}

variable "vpc_id" {
  description = ""
}
variable "zone_id" {
  description = ""
}
variable "cert_arn" {
  description = ""
}
variable "lb_zone_id" {
  description = ""
}

variable "cluster_id" {
  description = ""
}

variable "force_deploy" {
  description = ""
}

variable "private_subnets" {
  description = ""
}
variable "security_groups" {
  description = ""
}

variable "service_hostname" {
  description = ""
}

variable "domainname" {
  description = ""
}
variable "hostname" {
  description = ""
}

variable "taskdef_filename" {
  type = string
  description = "Template file name to build task definition from."
}

variable "use_https" {
  description = "Set to true to use HTTPS, false to use HTTP"
  type        = bool
}

variable "https_port" {
  description = "Port for HTTPS"
  type        = number
}

variable "http_port" {
  description = "Port for HTTP"
  type        = number
}
