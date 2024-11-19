resource "aws_elasticache_subnet_group" "elasticache_subnet" {
  name       = "${var.name}-cache-subnet"
  subnet_ids = [for subnet in module.vpc.private_subnets : subnet.id]
}

resource "aws_secretsmanager_secret" "elasticache_auth" {
  name                    = "${var.name}-elasticache-auth"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.encryption_secret.id
  #checkov:skip=CKV2_AWS_57: Disabled Secrets Manager secrets automatic rotation
}
resource "aws_secretsmanager_secret_version" "auth" {
  secret_id     = aws_secretsmanager_secret.elasticache_auth.id
  secret_string = random_password.auth.result
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group
resource "aws_elasticache_replication_group" "app4" {
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet.name
  replication_group_id       = var.name
  description                = "ElastiCache cluster for ${var.name}"
  node_type                  = "cache.t2.small"
  parameter_group_name       = "default.redis7.cluster.on"
  port                       = 6379
  multi_az_enabled           = true
  num_node_groups            = 3
  replicas_per_node_group    = 2
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.encryption_rest.id
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.auth.secret_string
  security_group_ids         = [aws_security_group.elasticache.id]
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.slow_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
  lifecycle {
    ignore_changes = [kms_key_id]
  }
  apply_immediately = true
}