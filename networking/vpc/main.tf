
# For variable descirptions, see `vars.tf`

# Modules used:
# - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.48.0

# VPC configuration start
# =======================
module "this" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "2.48.0"
  name               = var.name
  cidr               = var.cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  tags               = var.tags
}
# VPC configuration end
# =====================
