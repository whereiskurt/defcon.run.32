variable "private_subnets" {
  description = ""
}
variable "security_groups" {
  description = ""
}
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
variable "vpc_id" {
  type = string
  description = ""
}

variable "domainname" {
 type=string 
}
variable "db_name" {
  description = "Environment variable to publish."
}
variable "db_username" {
  description = "Environment variable to publish."
}
variable "db_password" {
  description = "Environment variable to publish."
}