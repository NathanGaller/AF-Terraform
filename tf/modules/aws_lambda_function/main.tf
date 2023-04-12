provider "archive" {}

locals {
  function_name = replace(basename(var.source_file_path), "/\\.[^.]*$/", "")
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "static/lambdasrc/${var.source_file_path}"
  output_path = "static/lambdasrc/zip/${basename(var.source_file_path)}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = local.function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = var.iam_role_arn
  handler          = "${local.function_name}.lambda_handler"
  runtime          = var.runtime

  # Pass environment variables
  environment {
    variables = var.environment_variables
  }
}

resource "aws_sns_topic" "lambda_topic" {
  name = "${local.function_name}-sns-topic"
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_lambda_permission" "sns_invoke_permission" {
  statement_id  = "AllowExecutionFromSNS${local.function_name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.lambda_topic.arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.lambda_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda.arn
  depends_on = [aws_lambda_permission.sns_invoke_permission]
}