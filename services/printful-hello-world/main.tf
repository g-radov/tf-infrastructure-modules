# For variable descriptions, see `vars.tf`

# Modules used:
# - https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.16.0
# - https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/2.20.0/submodules/iam-policy
# - https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/2.20.0/submodules/iam-assumable-role

# Resources used:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group

# Data sources used:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy

# ECS service configuration start
# ===============================
resource "aws_ecs_task_definition" "this" {
  family = var.family
  container_definitions = templatefile("task-definitions/service.json", {
    name                  = var.name
    image                 = var.container_image
    container_port        = var.container_port
    host_port             = var.container_port
    awslogs_group         = var.container_name
    awslogs_region        = var.region
    awslogs_stream_prefix = var.name
    }
  )
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = module.this_iam_exe_role.this_iam_role_arn
  network_mode       = "awsvpc"
  volume {
    name = "service-storage"
  }
  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.id
  desired_count   = var.desired_count
  lifecycle {
    ignore_changes = [desired_count]
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  network_configuration {
    subnets = var.subnets
    security_groups = flatten(
      [
        module.this_ecs_sg.this_security_group_id,
        var.security_groups,
      ]
    )
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.desired_count
  resource_id        = "service/${var.cluster}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "${var.name}-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value       = 75.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

module "this_ecs_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"
  name        = var.name
  description = "${var.name} - Security Group"
  vpc_id      = var.vpc_id
  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowECSCreateCloudWatchLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

module "this_iam_policy" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "~> 2.0"
  name        = var.name
  path        = "/"
  description = "${var.cluster} - IAM role policy"
  policy      = data.aws_iam_policy_document.this.json
}

module "this_iam_exe_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "~> 2.0"
  create_role       = true
  role_requires_mfa = false
  role_name         = "${var.name}-exe"
  role_description  = "${var.name} - task execution IAM role"
  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]
  custom_role_policy_arns = [
    module.this_iam_policy.arn,
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_cloudwatch_log_group" "container_logs" {
  name = var.container_name
  tags = var.tags
}
# ECS service configuration end
# =============================