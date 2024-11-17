module "vpc" {
  source                  = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.0"
  region                  = var.region
  vpc_cidr                = var.vpc_cidr
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  vpc_name                = "app-4"
  subnet_cidr_private     = var.subnet_cidr_private
  subnet_cidr_public      = var.subnet_cidr_public
  enable_internet_gateway = "true"
  enable_flow_log         = "true"
}