variable "region" {
  default = "us-east-1"
}
variable "label" {
  default = "rabbit"
}
variable "repository_tag" {
  default = "latest"
}
variable "domainname" {
  default = "defcon.run"
}
variable "githubdeploykey" {
  description = "Pull from TF_githubdeploykey to land in ParamStore secrets."
}

##StrapiDB is only available on private subnets and not publicly accessible
variable "STRAPI_DB_NAME" {
  description = "Environment variable to publish."
  default = "default-20240511"
}
variable "STRAPI_DB_USERNAME" {
  description = "Environment variable to publish."
  default = "default"
}
variable "STRAPI_DB_PASSWORD" {
  description = "Environment variable to publish."
  default = "default"
}