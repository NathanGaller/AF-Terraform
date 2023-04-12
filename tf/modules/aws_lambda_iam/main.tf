resource "aws_iam_policy" "lambda_iam_policy" {
  name        = "lambda_iam_policy"
  description = "IAM policy for AWS Lambda function"
  policy      = var.lambda_iam_policy_document
}

resource "aws_iam_role" "lambda_iam_role" {
  name               = "lambda_iam_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = {
    Terraform   = "true"
  }
}

resource "aws_iam_policy_attachment" "iam_policy_attachment_lambda_role_ng" {
  name       = "lambda_role_policy_attachment"
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
  roles      = [aws_iam_role.lambda_iam_role.name]
}