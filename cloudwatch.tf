resource "aws_cloudwatch_log_group" "slow_log" {
  name              = "/elasticache/${var.replication_group_id}/slow-log"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.encryption_rest.arn
}
resource "aws_cloudwatch_log_group" "engine_log" {
  name              = "/elasticache/${var.replication_group_id}/engine-log"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.encryption_rest.arn
}