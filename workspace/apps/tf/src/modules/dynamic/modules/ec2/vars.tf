variable "label" {
  description = "The Deployment labels"
}

variable "ec2_tags" {
  description = "Tags to apply to resources created by ec2 module"
  type        = map(string)
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "subnet_id" {
  description = "Subnet ID to created EC2 in"
}
variable "ec2key_name" {
  description = "The ec2 keyname to assign"
}
variable "security_groups_ids" {
  description = "Security groups to apply"
}

variable "instance_type" {
  description = "Security groups to apply"
}

variable "githubdeploykey" {
  description = "The SSM keyname with Github deploy key."
}
