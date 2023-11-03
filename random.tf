#https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/auth.html#auth-overview
resource "random_password" "auth" {
  length           = 90
  special          = true
  override_special = "!&#$^<>-"
}