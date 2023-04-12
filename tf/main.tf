terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.0"
    }

    # kubectl = {
    #   source = "gavinbunney/kubectl"
    #   version = "1.14.0"
    # }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }

  backend "s3" {
    bucket = "ng-aline-tfstate"
    key    = "terraform_state.tfstate"
    region = "us-west-2"
  }

}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# provider "aws_kms_secrets" {
#   region = var.aws_region
# }

provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = module.eks_cluster.eks_cluster_auth.token
  #load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }

}


provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = module.eks_cluster.eks_cluster_auth.token
    #load_config_file       = false
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}