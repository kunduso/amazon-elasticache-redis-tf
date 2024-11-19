module "vpc" {
  #CKV_TF_1: Ensure Terraform module sources use a commit hash
  #checkov:skip=CKV_TF_1: This is a self hosted module where the version number is tagged rather than the commit hash.
  source                  = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.1"
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