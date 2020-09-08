resource "aws_ecs_task_definition" "this" {
  family                = var.family
  container_definitions = file("task-definitions/service.json")
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu           = var.cpu
  memory        = var.memory
  task_role_arn = module.this_iam_role.this_iam_role_arn
  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.id
  desired_count   = var.desired_count
  iam_role        = module.this_iam_role.this_iam_role_arn
  depends_on = [
    module.this_iam_role.this_policy_arn
  ]
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = var.tags
}

module "this_iam_policy" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "~> 2.0"
  name        = var.name
  path        = "/"
  description = "${var.cluster} - IAM role policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "this_iam_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "~> 2.0"
  create_role       = true
  role_requires_mfa = false
  role_name         = var.name
  custom_role_policy_arns = [
    module.this_iam_policy.arn,
  ]
}
