# create a security group
resource "aws_security_group" "ec2_instance" {
  name        = "${var.name}-ec2"
  description = "Allow inbound to and outbound access from the Amazon EC2 instance."
  vpc_id      = aws_vpc.this.id
}
resource "aws_security_group_rule" "ec2_instance_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2_instance.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  description       = "Enable access from any resource inside the VPC."
}

resource "aws_security_group_rule" "ec2_instance_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ec2_instance.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Enable access to the internet."
}

#create an EC2 in a public subnet
data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = var.ami_name
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}
resource "aws_instance" "app-server-read" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.amazon_ami.id
  vpc_security_group_ids      = [aws_security_group.ec2_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  #checkov:skip=CKV_AWS_88: Required for Session Manager access
  subnet_id     = aws_subnet.public[0].id
  ebs_optimized = true
  monitoring    = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.name}-server-read"
  }
  user_data = templatefile("user_data/read_elasticache.tpl",
    {
      Region                 = var.region,
      elasticache_ep         = aws_ssm_parameter.elasticache_ep.name,
      elasticache_ep_port    = aws_ssm_parameter.elasticache_port.name,
      elasticache_auth_token = aws_secretsmanager_secret.elasticache_auth.name
  })
}
resource "aws_instance" "app-server-write" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.amazon_ami.id
  vpc_security_group_ids      = [aws_security_group.ec2_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  #checkov:skip=CKV_AWS_88: Required for Session Manager access
  subnet_id     = aws_subnet.public[0].id
  ebs_optimized = true
  monitoring    = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.name}-server-write"
  }
  user_data = templatefile("user_data/write_elasticache.tpl",
    {
      Region                 = var.region,
      elasticache_ep         = aws_ssm_parameter.elasticache_ep.name,
      elasticache_ep_port    = aws_ssm_parameter.elasticache_port.name,
      elasticache_auth_token = aws_secretsmanager_secret.elasticache_auth.name
  })
}