locals {
  default = {
    tags = {
      Terraform = true
    }
  }
}


module "this-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.39.0"
  name    = var.name
  cidr    = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = merge(local.default.tags, var.tags)

}

module "this-iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "2.10.0"
}

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "this-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "12.1.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.cluster_subnets
  vpc_id          = module.eks-vps.vpc_id

  worker_groups = [
    {
      instance_type = var.wg_instance_type
      asg_max_size  = var.wg_asg_max_size
    }
  ]
}
