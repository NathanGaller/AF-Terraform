output "region" {
  value       = var.aws_region
  description = "The AWS region where resources are provisioned."
}

output "cluster_name" {
  value       = var.cluster_name
  description = "The name of the EKS cluster."
}

output "aws_secret_key" {
  value       = var.aws_secret_key
  description = "The AWS secret key used for authentication."
}

output "aws_access_key" {
  value       = var.aws_access_key
  description = "The AWS access key used for authentication."
}