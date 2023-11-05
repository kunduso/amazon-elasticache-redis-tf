#https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/auth.html#auth-overview
#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "auth" {
  length           = 90
  special          = true
  override_special = "!&#$^<>-"
}