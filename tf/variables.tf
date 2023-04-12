
variable "account_id" {
  type        = number
  description = "AWS account number."
}

variable "user_group" {
  type        = string
  description = "AWS user group."
}

variable "username" {
  type        = string
  description = "AWS username."
}

variable "user_arn" {
  type        = string
  description = "AWS user ARN."
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  type        = string
  description = "AWS Region."
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name."
}