provider "aws" {
  region  = "us-east-1"
  version = "~> 2.43"
}

terraform {
  backend "s3" {
    bucket = "datasprints"
    key    = "yuriniitsuma/terraform.tfstate"
    region = "us-east-1"
  }
}

