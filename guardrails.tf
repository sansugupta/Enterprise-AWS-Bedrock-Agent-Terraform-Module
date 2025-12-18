resource "aws_bedrock_guardrail" "main_guardrail" {
  name                      = "${var.service_name}-guardrail"
  description               = "Minimal guardrail – only blocks competitor discussion"
  blocked_input_messaging   = "Sorry, I can't help with that."
  blocked_outputs_messaging = "I can't provide that information."

  topic_policy_config {
    topics_config {
      name       = "Competitors"
      definition = "Do not discuss competitors or other health insurance companies"
      examples   = ["Tell me about UnitedHealthcare", "How does Oscar compare?"]
      type       = "DENY"
    }
  }
  tags = var.tags
}
