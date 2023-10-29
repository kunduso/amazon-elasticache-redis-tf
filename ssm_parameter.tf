#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
resource "aws_ssm_parameter" "elasticache_ep" {
  name  = "/elasticache/${aws_elasticache_replication_group.app4.replication_group_id}/endpoint"
  type  = "String"
  value = aws_elasticache_replication_group.app4.configuration_endpoint_address
}
resource "aws_ssm_parameter" "elasticache_port" {
  name  = "/elasticache/${aws_elasticache_replication_group.app4.replication_group_id}/port"
  type  = "String"
  value = aws_elasticache_replication_group.app4.port
}