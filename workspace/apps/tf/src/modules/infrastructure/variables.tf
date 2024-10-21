variable "region" {
  default = "us-east-1"
}

variable "azs" {
  type        = list(any)
  description = "Environment tag applied to all resources"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
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
  description = "Label tag applied to all resources"
}

variable "global_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"] //List of Public subnet cidr range
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
  default     = ["10.0.101.0/24", "10.0.102.0/24"] //List of private subnet cidr range
}

variable "domainname" {
 type=string 
}

variable "enable_lb_delete_protection" {
  default = false
}

variable "githubdeploykey" {
  description = "Github secret private key for deployments against repo."
  sensitive = true
}
variable "db_name" {
}
variable "db_username" {
}
variable "db_password" {
  sensitive = true
}

variable "bucket_name" {
}
variable "bucket_cnames" {
  type=list(string)
}

variable "with_RDS" {
  type = bool
}
variable "with_S3" {
  type = bool
}