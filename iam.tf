# --- Lambda Role ---
resource "aws_iam_role" "bedrock_lambda_role" {
  name = "${var.service_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name   = "${var.service_name}-lambda-logging-policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
      Effect   = "Allow",
      Resource = "${aws_cloudwatch_log_group.bedrock_lambda_logs.arn}:*"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_logging_attachment" {
  role       = aws_iam_role.bedrock_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

# --- Bedrock Agent Role ---
resource "aws_iam_role" "bedrock_agent_role" {
  name = "${var.service_name}-agent-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "bedrock.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "bedrock_agent_permissions" {
  name   = "${var.service_name}-agent-permissions-policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "bedrock:InvokeModel",
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
      },
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = aws_lambda_function.context_retrieval_lambda.arn
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "agent_permissions_attachment" {
  role       = aws_iam_role.bedrock_agent_role.name
  policy_arn = aws_iam_policy.bedrock_agent_permissions.arn
}
