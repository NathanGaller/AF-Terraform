output "eks_cluster" {
  value = data.aws_eks_cluster.default
}

output "eks_cluster_auth" {
  value = data.aws_eks_cluster_auth.default
}

output "worker_sec_group" {
  value = module.eks.node_security_group_id
}