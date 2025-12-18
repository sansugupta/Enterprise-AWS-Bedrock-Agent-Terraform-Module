variable "service_name" {
  type        = string
  description = "The unique name for the service, used to prefix all resources."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources in the module."
  default     = {}
}
