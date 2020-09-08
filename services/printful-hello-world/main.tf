resource "aws_ecs_task_definition" "this" {
  family                = var.family
  container_definitions = file("task-definitions/service.json")
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu                = var.cpu
  memory             = var.memory
  task_role_arn      = module.this_iam_role.this_iam_role_arn
  execution_role_arn = module.this_iam_role.this_iam_role_arn
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
  # tags = var.tags
}

module "this_ecs_sg" {
  source      = "terraform-aws-modules/security-group/aws"
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

module "this_iam_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "~> 2.0"
  create_role       = true
  role_requires_mfa = false
  role_name         = var.name
  role_description  = "${var.name} - IAM role"
  trusted_role_services = [
    "ecs.amazonaws.com",
    "ecs-tasks.amazonaws.com"
  ]
  custom_role_policy_arns = [
    module.this_iam_policy.arn
  ]
}
