
resource "aws_kms_key" "encryption_secret" {
  enable_key_rotation     = true
  description             = "Key to encrypt secret"
  deletion_window_in_days = 7

  # Attach the KMS key policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSecretsManagerUse"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
      },
      {
        Sid      = "AllowAdminAccessToKMSKey"
        Effect   = "Allow"
        Action   = "kms:*"
        Resource = "*"
        Principal = {
          AWS = "*"
        }
      },
      {
        Sid    = "AllowIAMRolesToUseKey"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
        Principal = {
          AWS = "*"
        }
        Condition = {
          StringEquals = {
            "kms:CallerAccount" = "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.name}-encryption-secret"
  }
}

resource "aws_kms_alias" "encryption_secret" {
  name          = "alias/${var.name}-elasticache-in-transit"
  target_key_id = aws_kms_key.encryption_secret.key_id
}
resource "aws_kms_key" "encryption_rest" {
  enable_key_rotation     = true
  description             = "Key to encrypt cache at rest."
  deletion_window_in_days = 7
  #checkov:skip=CKV2_AWS_64: KMS Key policy in a separate resource
  tags = {
    Name = "${var.name}-encryption-rest"
  }
}
resource "aws_kms_alias" "encryption_rest" {
  name          = "alias/${var.name}-elasticache-at-rest"
  target_key_id = aws_kms_key.encryption_rest.key_id
}
resource "aws_kms_key_policy" "encryption_rest_policy" {
  key_id = aws_kms_key.encryption_rest.id
  policy = jsonencode({
    Id = "${var.name}-encryption-rest"
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