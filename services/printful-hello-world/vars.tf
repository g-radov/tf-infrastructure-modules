# shared variables start
# ======================
variable "name" {
  type        = string
  description = "Name assigned to provisioned resources."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "region" {
  type        = string
  description = "AWS region used for provisioned resources."
}

variable "container_port" {
  type        = number
  description = "The port on the container to associate with the load balancer."
  default     = null
}

variable "container_name" {
  type        = string
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)."
  default     = null
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running."
  default     = 3
}
# shared variables end
# ====================

# aws_ecs_task_definition.this variables start
# ============================================
variable "family" {
  type        = string
  description = "A unique name for your task definition."
}

variable "container_image" {
  type        = string
  description = "Docker image used for launching containers."
  default     = null
}

variable "cpu" {
  type        = number
  description = "The number of cpu units used by the task."
  default     = 512
}

variable "memory" {
  type        = number
  description = "The number of cpu units used by the task."
  default     = 1024
}
# aws_ecs_task_definition.this variables end
# ==========================================

# aws_ecs_service.this variables start
# ====================================
variable "cluster" {
  type        = string
  description = "ARN of an ECS cluster."
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the Load Balancer target group to associate with the service."
  default     = null
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnets to launch ECS service in."
  default     = null
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security groups to assign to ECS service."
  default     = null
}

# aws_appautoscaling_target.ecs_target variables start
# ====================================================
variable "max_capacity" {
  type        = number
  description = "The upper limit of ECS task scaling."
  default     = 6
}
# aws_appautoscaling_target.ecs_target variables end
# ==================================================

# module.this_ecs_sg variables start
# ==================================
variable "vpc_id" {
  description = "VPC ID for ECS service security group."
  type        = string
  default     = null
}
# module.this_ecs_sg variables end
# ================================
