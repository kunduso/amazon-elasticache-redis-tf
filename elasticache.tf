resource "aws_elasticache_subnet_group" "elasticache_subnet" {
  name       = "cache-subnet"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}
resource "aws_kms_key" "encrytion_rest" {
  enable_key_rotation     = true
  description             = "Key to encrypt cache at rest"
  deletion_window_in_days = 7
}
resource "aws_kms_key" "encrytion_secret" {
  enable_key_rotation     = true
  description             = "Key to encrypt secret"
  deletion_window_in_days = 7
}
resource "aws_secretsmanager_secret" "elasticache_auth" {
  name                    = "elasticache_auth"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.encrytion_secret.id
}
resource "aws_secretsmanager_secret_version" "auth" {
  secret_id     = aws_secretsmanager_secret.elasticache_auth.id
  secret_string = var.elasticache_auth
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group
resource "aws_elasticache_replication_group" "app4" {
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet.name
  replication_group_id       = "app4-redis-cluster"
  description                = "ElastiCache cluster for app4"
  node_type                  = "cache.t2.small"
  parameter_group_name       = "default.redis7.cluster.om"
  port                       = 6379
  multi_az_enabled           = true
  num_node_groups            = 3
  replicas_per_node_group    = 2
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.encrytion_rest.id
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.auth.secret_string
  security_group_ids         = [aws_security_group.elasticache.id]
  lifecycle {
    ignore_changes = [kms_key_id]
  }
  apply_immediately = true
}