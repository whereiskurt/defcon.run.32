terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
      configuration_aliases = [
        aws.app,
        aws.management
      ]
    }
  }
  required_version = ">= 1.8.1"
}
