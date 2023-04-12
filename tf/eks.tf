module "eks_cluster" {
  source                         = "./modules/ng_eks_module"
  cluster_name                   = var.cluster_name
  cluster_version                = "1.25"
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  lambda_iam_role_arn            = module.lambda_iam.lambda_iam_role_arn
  eks_managed_node_groups = {
    workers = {
      min_size       = 0
      max_size       = 5
      desired_size   = 3
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
    }
  }
  eks_cluster_domain = "alinefinancial.pro"
  external_dns_route53_zone_arns = [
    "arn:aws:route53:::hostedzone/Z0782552YNR32UAFYCSH"
  ]
}