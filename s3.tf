resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "bedrock_context_docs" {
  bucket = "${var.service_name}-context-docs-${random_id.bucket_suffix.hex}"
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bedrock_context_docs_encryption" {
  bucket = aws_s3_bucket.bedrock_context_docs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.bedrock_key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bedrock_context_docs_public_access" {
  bucket                  = aws_s3_bucket.bedrock_context_docs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
