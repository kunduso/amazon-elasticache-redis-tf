terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Source = "https://github.com/kunduso/add-asg-elb-terraform"
    }
  }
}
provider "random" {
  # Configuration options
}