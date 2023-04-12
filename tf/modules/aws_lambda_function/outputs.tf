output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.lambda_topic.arn
}