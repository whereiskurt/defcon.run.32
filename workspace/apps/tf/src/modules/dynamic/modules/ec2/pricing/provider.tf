terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
  }
  required_version = ">= 1.8.1"

  backend "s3" {
    encrypt        = true
    bucket         = "defcon-run-20240420-tf-state"
    dynamodb_table = "defcon-run-20240420-tf-lock"
    key            = "terraform.tfstate.dynamic"
    region         = "us-east-1"
    profile        = "terraform"
  }
}

provider "aws" {
  alias   = "terraform"
  region  = "us-east-1"
  profile = "terraform"
}

provider "aws" {
  alias   = "app"
  region  = "us-east-1"
  profile = "application"
}

provider "aws" {
  alias   = "auth"
  region  = "us-east-1"
  profile = "application"
}

provider "aws" {
  alias   = "admin"
  region  = "us-east-1"
  profile = "application"
}

provider "aws" {
  alias   = "management"
  region  = "us-east-1"
  profile = "management"
}
