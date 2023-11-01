locals {
  account_id = aws_vpc.this.owner_id
}
#Create a policy to read from the specific parameter store
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "ssm_parameter_policy" {
  name        = "app-4-ssm-parameter-read-policy"
  path        = "/"
  description = "Policy to read the ElastiCache endpoint and port number stored in the SSM Parameter Store."
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = [aws_ssm_parameter.elasticache_ep.arn, aws_ssm_parameter.elasticache_port.arn]
      }
    ]
  })
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "secret_manager_policy" {
  name        = "app-4-secret-read-policy"
  path        = "/"
  description = "Policy to read the ElastiCache AUTH Token stored in AWS Secrets Manager secret."
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ]
        Resource = [aws_kms_key.encrytion_rest.arn]
      }
    ]
  })
}