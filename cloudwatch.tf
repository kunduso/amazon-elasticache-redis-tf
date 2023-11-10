resource "aws_cloudwatch_log_group" "slow_log" {
  name              = "/elasticache/${aws_elasticache_replication_group.app4.replication_group_id}/slow-log"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encrytion_rest.id
}
resource "aws_cloudwatch_log_group" "engine_log" {
  name              = "/elasticache/${aws_elasticache_replication_group.app4.replication_group_id}/engine-log"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encrytion_rest.id
}
