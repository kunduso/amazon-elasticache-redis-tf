#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "elasticache_ep" {
  name   = "/elasticache/app-4/${aws_elasticache_replication_group.app4.replication_group_id}/endpoint"
  type   = "SecureString"
  #key_id = aws_kms_key.encryption_rest.id
  value  = aws_elasticache_replication_group.app4.configuration_endpoint_address
}
resource "aws_ssm_parameter" "elasticache_port" {
  name   = "/elasticache/app-4/${aws_elasticache_replication_group.app4.replication_group_id}/port"
  type   = "SecureString"
  #key_id = aws_kms_key.encryption_rest.id
  value  = aws_elasticache_replication_group.app4.port
}