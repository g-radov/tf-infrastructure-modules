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
    module.this_alb_sg_server.this_security_group_id
  ]
  target_groups = [
    {
      name_prefix      = "ecs-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      health_check = {
        matcher = "200"
      }
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags              = var.tags
  target_group_tags = var.tags
}

module "this_alb_sg_server" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.name}-alb-server"
  description         = "${var.name} - ALB security group (server)"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules = [
    "http-80-tcp"
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.this_alb_sg_client.this_security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "this_alb_sg_client" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.name}-alb-client"
  description = "${var.name} - security group (client)"
  vpc_id      = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.this_alb_sg_server.this_security_group_id
    }
  ]
}
# ALB configuration end
# =====================

# ECS cluster configuration start
# ===============================
resource "aws_ecs_cluster" "this" {
  name = var.name
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]
}
# ECS cluster configuration end
# =============================
