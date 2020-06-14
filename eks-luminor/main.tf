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
  cluster_name    = var.name
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

module "this-iam-role-admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"
  trusted_role_arns = [
    module.this-iam-group-admin.arn
  ]
  create_role       = true
  role_name         = "eks-luminor-admin"
  role_requires_mfa = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
    "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
  ]
}

module "this-iam-group-admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 2.0"
  name    = "eks-luminor-admin"
  assumable_roles = [
    module.this-iam-role-admin.arn
  ]
  group_users = [
    module.this-iam-user-admin.id
  ]
}

module "this-iam-user-admin" {
  source                  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                 = "~> 2.0"
  name                    = "eks-luminor-admin"
  force_destroy           = true
  pgp_key                 = "keybase:test"
  password_reset_required = false
}





#module "this-read-only-user" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
#  version = "~> 2.0"
#
#  name          = "eks-read-only-user"
#  force_destroy = true
#
#  pgp_key = "keybase:test"
#
#  password_reset_required = false
#}
#
#
#
#module "this-read-only-role" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#  version = "~> 2.0"
#
#  trusted_role_arns = [
#    "arn:aws:iam::307990089504:root",
#    "arn:aws:iam::835367859851:user/anton",
#  ]
#
#  create_role = true
#
#  role_name         = "${var.name}-admin"
#  role_requires_mfa = true
#
#  custom_role_policy_arns = [
#    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
#    "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
#  ]
#}
#
#
#
#module "this-eks-read-only" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
#  version = "~> 2.0"
#
#  name = "eks-luminor-read-only"
#
#  assumable_roles = [
#    "arn:aws:iam::835367859855:role/readonly" # these roles can be created using `iam_assumable_roles` submodule
#  ]
#
#  group_users = [
#    "user1",
#    "user2"
#  ]
#}
