output "ecs_service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "ecs_service_cluster_arn" {
  description = "ECS cluster ARN which the service runs on."
  value       = aws_ecs_service.this.cluster
}

output "ecs_task_cloudwatch_log_group_name" {
  description = "CloudWatch log group where task containers write logs."
  value       = aws_cloudwatch_log_group.container_logs.name
}
