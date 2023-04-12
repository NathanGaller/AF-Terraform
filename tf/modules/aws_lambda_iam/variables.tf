# variable "lambda_function_name" {
#   type        = string
#   description = "Name of the AWS Lambda function"
# }

# variable "lambda_iam_policy_name" {
#   type        = string
#   description = "Name of the AWS IAM policy for the Lambda function"
# }

# variable "lambda_iam_policy_description" {
#   type        = string
#   description = "Description of the AWS IAM policy for the Lambda function"
# }

variable "lambda_iam_policy_document" {
  type        = string
  description = "JSON-encoded IAM policy document for the Lambda function"
}
