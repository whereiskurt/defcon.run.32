variable "label" {
  description = "The Deployment labels"
}
variable "secret_tags" {
  description = "Tags to apply to resources created by secret module"
  type        = map(string)
}
variable "githubdeploykey" {
  description = "Github secret private key for deployments against repo."
  sensitive = true
}
variable "domainname" {
  description = "Full release name like defcon.run"
}