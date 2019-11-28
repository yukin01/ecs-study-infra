terraform {
  required_version = ">= 0.12"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "yukin01"

    workspaces {
      name = "fargate-study-infra"
    }
  }
}

provider "aws" {
  version = "~> 2.40.0"
  region  = "ap-northeast-1"
}
