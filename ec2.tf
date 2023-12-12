resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "app-4-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this-igw.id
}
# create a security group
resource "aws_security_group" "ec2_instance" {
  name        = "app-4-ec2"
  description = "Allow inbound to and outbound access from the Amazon EC2 instance."
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "Enable access from any resource inside the VPC."
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Enable access to the internet."
  }
  vpc_id = aws_vpc.this.id
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
  subnet_id                   = aws_subnet.public[0].id
  tags = {
    Name = "app-4-server-read"
  }
  user_data = templatefile("user_data/read_elasticache.tpl",
    {
      Region         = var.region,
      elasticache_ep = aws_ssm_parameter.elasticache_ep.name,
      elasticache_ep_port = aws_ssm_parameter.elasticache_port.name,
      elasticache_auth_token = aws_secretsmanager_secret.elasticache_auth.name
  })
}
resource "aws_instance" "app-server-write" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.amazon_ami.id
  vpc_security_group_ids      = [aws_security_group.ec2_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public[0].id
  tags = {
    Name = "app-4-server-write"
  }
  user_data = templatefile("user_data/write_elasticache.tpl",
    {
      Region         = var.region,
      elasticache_ep = aws_ssm_parameter.elasticache_ep.name,
      elasticache_ep_port = aws_ssm_parameter.elasticache_port.name,
      elasticache_auth_token = aws_secretsmanager_secret.elasticache_auth.name
  })
}