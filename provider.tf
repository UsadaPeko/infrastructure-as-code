terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "rhea-so-lab"

    workspaces {
      name = "infrastructure-as-code"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}
