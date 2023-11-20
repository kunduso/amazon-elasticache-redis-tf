
resource "aws_kms_key" "encryption_secret" {
  enable_key_rotation     = true
  description             = "Key to encrypt secret"
  deletion_window_in_days = 7
  #checkov:skip=CKV2_AWS_64: Not including a KMS Key policy
}
resource "aws_kms_alias" "encryption_secret" {
  name          = "alias/elasticache-app-4-in-transit"
  target_key_id = aws_kms_key.encryption_secret.key_id
}
resource "aws_kms_key" "encryption_rest" {
  enable_key_rotation     = true
  description             = "Key to encrypt cache at rest."
  deletion_window_in_days = 7
  #checkov:skip=CKV2_AWS_64: KMS Key policy in a separate resource
}
resource "aws_kms_alias" "encryption_rest" {
  name          = "alias/elasticache-app-4-at-rest"
  target_key_id = aws_kms_key.encryption_rest.key_id
}
resource "aws_kms_key_policy" "encryption_rest_policy" {
  key_id = aws_kms_key.encryption_rest.id
  policy = jsonencode({
    Id = "encryption-rest"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "${local.principal_root_arn}"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
      {
        Effect : "Allow",
        Principal : {
          Service : "${local.principal_logs_arn}"
        },
        Action : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource : "*",
        Condition : {
          ArnEquals : {
            "kms:EncryptionContext:aws:logs:arn" : [local.slow_log_arn, local.engine_log_arn]
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}