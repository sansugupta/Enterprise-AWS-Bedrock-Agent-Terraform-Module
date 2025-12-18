data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "context_retrieval_lambda" {
  function_name    = "${var.service_name}-context-retrieval-lambda"
  role             = aws_iam_role.bedrock_lambda_role.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "app.lambda_handler"
  runtime          = "python3.11"
  timeout          = 30
  kms_key_arn      = aws_kms_key.bedrock_key.arn

  environment {
    variables = {
      OPENSEARCH_ENDPOINT = "https://placeholder-for-opensearch.com"
    }
  }
  tags = var.tags
}
