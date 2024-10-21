data "external" "spot_price_history" {
  program = ["./get_price.sh", "us-east-1", "us-east-1a", "t4g.2xlarge"] 
  
}
output "average_spot_price" {
  value =  data.external.spot_price_history.result["average"]
}
output "last_spot_price" {
  value =  data.aws_ec2_spot_price.last_price.spot_price
}
data "aws_ec2_spot_price" "last_price" {
  instance_type     = var.instance_type
  availability_zone = var.azs[0]

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
  provider = aws.app
}

variable "azs" {
  type        = list(any)
  description = "Environment tag applied to all resources"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "instance_type" {
  default = "t4g.2xlarge"
}