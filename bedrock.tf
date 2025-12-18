resource "aws_bedrockagent_agent" "main_agent" {
  agent_name              = "${var.service_name}-main-agent"
  agent_resource_role_arn = aws_iam_role.bedrock_agent_role.arn
  foundation_model        = "anthropic.claude-3-sonnet-20240229-v1:0"
  instruction             = "You are a helpful assistant designed to answer questions about insurance plan management. Use the provided tools to find the most accurate information."
  tags                    = var.tags
}

resource "aws_bedrockagent_agent_action_group" "retrieval_action_group" {
  agent_id      = aws_bedrockagent_agent.main_agent.id
  agent_version = "DRAFT"
  action_group_name = "ContextRetrieval"
  description       = "Action group to retrieve context from the knowledge pipeline."

  action_group_executor {
    lambda = aws_lambda_function.context_retrieval_lambda.arn
  }

  api_schema {
    payload = jsonencode({
      openapi = "3.0.0",
      info = {
        title   = "ContextRetrievalAPI",
        version = "1.0"
      },
      paths = {
        "/retrieve" = {
          post = {
            summary = "Retrieves context for a given query.",
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
        }
      }
    })
  }
}

resource "aws_bedrockagent_agent_alias" "dev_alias" {
  agent_id         = aws_bedrockagent_agent.main_agent.id
  agent_alias_name = "dev-pink"
  tags             = var.tags
}
