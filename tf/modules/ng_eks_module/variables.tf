variable "cluster_name" {
  description = "Name of the EKS cluster."
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
}

variable "cluster_endpoint_public_access" {
  description = "Set to true to enable public access to the EKS cluster endpoint."
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed."
}

variable "subnet_ids" {
  description = "List of IDs of the subnets where the EKS cluster will be deployed."
  type        = list(string)
}

variable "lambda_iam_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}

variable "eks_managed_node_groups" {
  description = "A map of managed node group configurations."
  type        = map(object({
    min_size        = number
    max_size        = number
    desired_size    = number
    instance_types  = list(string)
    capacity_type   = string
  }))
}

variable "eks_cluster_domain" {
  description = "Domain name for the EKS cluster."
}

variable "external_dns_route53_zone_arns" {
  description = "List of ARNs for the Route 53 Hosted Zones to use with external DNS."
  type        = list(string)
}