locals {
  default = {
    tags = {
      Environment = var.environment
      Terraform   = true
    }
  }
}

module "this-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.39.0"
  name    = "vpc-${var.name}"
  cidr    = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = merge(
    local.default.tags,
    var.tags
  )
}

module "this-iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "2.10.0"
}

data "aws_eks_cluster" "cluster" {
  name = module.this-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.this-cluster.cluster_id
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
  cluster_name    = "eks-${var.name}"
  cluster_version = var.cluster_version
  subnets         = module.this-vpc.private_subnets
  vpc_id          = module.this-vpc.vpc_id
  worker_groups = [
    {
      instance_type = var.wg_instance_type
      asg_max_size  = var.wg_asg_max_size
    }
  ]
}
