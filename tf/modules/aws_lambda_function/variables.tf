variable "source_file_path" {
  type        = string
  description = "Path to the source file for the AWS Lambda function"
}

variable "runtime" {
  type        = string
  description = "Runtime environment for the AWS Lambda function"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the AWS Lambda function"
}

variable "iam_role_arn" {
  type        = string
  description = "ARN of the AWS IAM role for the Lambda function"
}