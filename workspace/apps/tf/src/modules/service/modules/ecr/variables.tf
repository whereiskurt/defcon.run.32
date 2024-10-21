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

variable "ecr_tags" {
  description = "Tags to apply to resources created by module"
  type        = map(string)
  default     = {}
}

variable "name" {
  type        = string
  description = "Label tag applied to all resources"
}

