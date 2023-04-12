module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.7.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  eks_managed_node_groups = var.eks_managed_node_groups
}


resource "aws_iam_policy" "external_dns" {
  name        = "external_dns_policy_NG"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints/modules/kubernetes-addons"

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version
  eks_cluster_domain   = var.eks_cluster_domain
  
  #data_plane_wait_arn = join(",", [for prof in module.eks.fargate_profiles : prof.fargate_profile_arn])
  
  enable_amazon_eks_vpc_cni    = true
  enable_amazon_eks_coredns    = true
  enable_amazon_eks_kube_proxy = true
  
  enable_aws_load_balancer_controller   = true
  enable_external_dns                   = true
  enable_metrics_server                 = true
  enable_aws_cloudwatch_metrics         = true
  
  enable_secrets_store_csi_driver       = true
  enable_external_secrets               = true
  #enable_karpenter                      = true
  
  external_dns_route53_zone_arns = var.external_dns_route53_zone_arns
  
  external_dns_irsa_policies = [
    resource.aws_iam_policy.external_dns.arn
  ]
  
  depends_on = [module.eks.cluster_id]
}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name
  
  depends_on = [module.eks.cluster_id]
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
  
  depends_on = [module.eks.cluster_id]
}