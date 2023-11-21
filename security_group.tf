resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
}
resource "aws_security_group" "elasticache" {
  name        = "app-4-elasticache-sg"
  description = "Allow inbound to and outbound access from the Amazon ElastiCache cluster."
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Enable communication to the Amazon ElastiCache for Redis cluster. "
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable access to the ElastiCache cluster."
  }
  vpc_id = aws_vpc.this.id
}