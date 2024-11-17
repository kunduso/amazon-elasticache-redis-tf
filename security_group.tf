#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "elasticache" {
  name        = "${var.name}-elasticache-sg"
  description = "Allow inbound to and outbound access from the Amazon ElastiCache cluster."
  vpc_id      = module.vpc.vpc.id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "elasticache_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.elasticache.id
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  description       = "Enable communication to the Amazon ElastiCache for Redis cluster."
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "elasticache_egress" {
  type              = "egress"
  security_group_id = aws_security_group.elasticache.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Enable access to the ElastiCache cluster."
}