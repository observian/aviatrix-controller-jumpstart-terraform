# Replace the organization name with your tf cloud organization name, as well as the workspace with your workspace's name if you opt to rename it
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "<REPLACE ME>"

    workspaces {
      name = "aviatrix-controller-jumpstart-terraform"
    }
  }

  required_providers {
    aws = {
      version = "~>2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
