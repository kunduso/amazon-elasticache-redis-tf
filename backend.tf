terraform {
  backend "s3" {
    bucket  = "kunduso-terraform-remote-bucket"
    encrypt = true
    key     = "tf/amazon-elasticache-redis-tf/terraform.tfstate"
    region  = "us-east-2"
  }
}