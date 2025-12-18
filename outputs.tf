output "bedrock_agent_alias_name" {
  description = "The name of the Bedrock Agent alias created."
  value       = aws_bedrockagent_agent_alias.dev_alias.agent_alias_name
}

output "context_docs_s3_bucket_id" {
  description = "The ID of the S3 bucket for context documents."
  value       = aws_s3_bucket.bedrock_context_docs.id
}
