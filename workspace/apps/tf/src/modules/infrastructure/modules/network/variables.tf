variable "label" {
  description = "The Deployment labels"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

variable "network_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
}
variable "domainname" {
 type=string 
}
variable "enable_lb_delete_protection" {
  type=bool
}