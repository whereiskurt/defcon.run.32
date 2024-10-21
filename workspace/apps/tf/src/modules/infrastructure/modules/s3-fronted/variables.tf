variable "label" {
  description = "The Deployment labels"
}
variable "domainname" {
  description = "Full release name like defcon.run"
}
variable "bucket_tags" {
  type        = map(string)
}
variable "bucket_name" {
  type        = string
}

variable "bucket_cnames" {
  type        = list(string)
}

variable "certificate_arn" {
  type        = string
}
variable "zone_id" {
  type        = string
}

variable "role_arn" {
  type = string
}