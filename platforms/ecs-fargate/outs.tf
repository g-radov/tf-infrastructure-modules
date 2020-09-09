# module.this_alb outputs start
# =============================
output "alb_arn" {
  description = "The ARN of the load balancer."
  value       = module.this_alb.this_lb_arn
}

output "target_group_arns" {
  description = "ARN suffixes of our target groups."
  value       = module.this_alb.target_group_arns
}

output "target_group_names" {
  description = "Names of the target group."
  value       = module.this_alb.target_group_names
}
# module.this_alb outputs end
# ===========================

# module.this_alb_sg_server/client outputs start
# ==============================================
output "alb_sg_client_id" {
  description = "the ID of the ALB client security group."
  value       = module.this_alb_sg_client.this_security_group_id
}
# module.this_alb_sg_server/client outputs end
# ============================================

# aws_ecs_cluster.this outputs start
# ==================================
output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.this.arn
}
# aws_ecs_cluster.this outputs end
# ================================
