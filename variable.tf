#Define AWS Region
variable "region" {
  description = "AWS Cloud infrastructure region."
  type        = string
  default     = "us-east-2"
}
#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}
variable "name" {
  description = "The name of the application."
  type        = string
  default     = "app-4"
}
variable "vpc_cidr" {
  description = "CIDR for the VPC."
  default     = "10.20.32.0/25"
}
variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets."
  default     = ["10.20.32.0/27", "10.20.32.32/27", "10.20.32.64/27"]
  type        = list(any)
}
variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets."
  default     = ["10.20.32.96/27"]
  type        = list(any)
}
variable "ami_name" {
  description = "The ami name of the image from where the instances will be created"
  default     = ["amzn2-ami-amd-hvm-2.0.20230727.0-x86_64-gp2"]
  type        = list(string)
}
variable "instance_type" {
  description = "The instance type of the EC2 instances"
  default     = "t3.medium"
}
# variable "replication_group_id" {
#   description = "The name of the ElastiCache replication group."
#   default     = "app-4-redis-cluster"
#   type        = string
# }