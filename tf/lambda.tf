module "lambda_iam" {
  source = "./modules/aws_lambda_iam"

  lambda_iam_policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "eks:DeleteCluster",
        "eks:ListNodegroups",
        "eks:DescribeNodegroup",
        "eks:DeleteNodegroup",
        "cloudformation:DeleteStack"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}