resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
}