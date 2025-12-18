resource "aws_kms_key" "bedrock_key" {
  description             = "KMS key for Bedrock encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "bedrock_key_alias" {
  name          = "alias/bedrock-${var.service_name}-key"
  target_key_id = aws_kms_key.bedrock_key.key_id
}
