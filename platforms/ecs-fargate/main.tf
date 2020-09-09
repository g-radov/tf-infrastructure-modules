
# For variable descriptions, see `vars.tf`

# Modules used:
# - https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/5.8.0
# - https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.16.0
 
# Resources used:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster

# ALB configuration start
# =======================
module "this_alb" {
  # Create a application load balancer, target group and a HTTP listener,
  # which will be used as a front-end for a ECS service.
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

# ALB security groups are created using `client/server` principle.
module "this_alb_sg_server" {
  # Create server-security group for the application load balancer
  # created previously. This security group will permit access from
  # services, which have client-security group assigned to them.
  source              = "terraform-aws-modules/security-group/aws"
  version             = "3.16.0"
  name                = "${var.name}-alb-server"
  description         = "${var.name} - ALB security group (server)"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  # Allow ingress HTTP traffic.
  ingress_rules = [
    "http-80-tcp"
  ]
  # Allow all traffic within the security group.
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.this_alb_sg_client.this_security_group_id
    }
  ]
  # Allow egress all traffic. 
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "this_alb_sg_client" {
  # Create client-security group, which works in conjunction
  # with server-security group created previously.
  source      = "terraform-aws-modules/security-group/aws"
  version     = "3.16.0"
  name        = "${var.name}-alb-client"
  description = "${var.name} - security group (client)"
  vpc_id      = var.vpc_id
  # Allow all ingress from server-security group
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
# Create ECS cluster, which will be used
# for running ECS services
resource "aws_ecs_cluster" "this" {
  name = var.name
  # Enable Fargate capacity providers
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]
}
# ECS cluster configuration end
# =============================
