resource "aws_cloudwatch_log_group" "bedrock_lambda_logs" {
  name              = "/aws/lambda/${var.service_name}-retrieve-lambda-logs"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.bedrock_key.arn
  tags              = var.tags
}
