#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "slow_log" {
  name              = "/elasticache/${var.name}/slow-log"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.encryption_rest.arn
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "engine_log" {
  name              = "/elasticache/${var.name}/engine-log"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.encryption_rest.arn
}