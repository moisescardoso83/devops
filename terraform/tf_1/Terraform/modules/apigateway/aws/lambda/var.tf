variable "function_name" {
  description = "The name of the lambda function"
}

variable "authorizer_name" {
  description = "The name of the authorier for api to lambda function"
}

variable "runtime" {
  description = "The runtime of the lambda to create"
}

variable "handler" {
  description = "The handler name of the lambda function"
}

variable "role" {
  description = "IAM role attached to the Lambda Function (ARN)"
}

variable "app_config" {
  description = "Application config url"
  default     = "../config/env.py"
}

variable "policy" {
  description = "Policy arn to access, execute api"
}

variable "panel_url" {
  description = "Policy arn to access, execute api"
}

variable "source_code_hash" {}


variable "file_name" {
  description = "name of the file that will be extracted"
}
variable "rest_api_id" {

}
variable "identity_source" {
  description = "Token Source for authorizer"
}