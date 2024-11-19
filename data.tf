data "aws_caller_identity" "current" {}
locals {
  principal_root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  principal_logs_arn = "logs.${var.region}.amazonaws.com"
  slow_log_arn       = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${var.name}/slow-log"
  engine_log_arn     = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${var.name}/engine-log"
}