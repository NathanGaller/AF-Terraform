terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
 
  backend "s3" {
    bucket = "ng-aline-tfstate"
    key    = "terraform_cloudformation.tfstate"
    region = "us-west-2"
  }

}
   
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_cloudformation_stack" "cloudformation_stack" {
  name = "ng-cloudformation-stack"
  template_body = file("${path.module}/static/cloudformation.yaml")
  parameters = {
    #ClusterName = "ng-eks-cloudformation"
    VPCName = "ng-cloudformation-vpc"
  }
}