# ALB configuration start
# =======================
module "this_alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = var.name
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups = [
    module.this_alb_sg.this_security_group_id
  ]
  target_groups = [
    {
      name             = var.name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags = var.tags
}

module "this_alb_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = var.name
  description         = "${var.name} - Security Group"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules = [
    "http-80-tcp"
  ]
}
# ALB configuration end
# =====================

# ECS Cluster configuration start
# ===============================
resource "aws_ecs_cluster" "this" {
  name = var.name
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]
}

