variable "family" {
  type        = string
  description = "A unique name for your task definition"
}

variable "cpu" {
  type        = number
  description = "The number of cpu units used by the task."
  default     = 10
}

variable "memory" {
  type        = number
  description = "The number of cpu units used by the task."
  default     = 128
}

variable "name" {
  type        = string
  description = "ECS service name."
  default     = null
}

variable "cluster" {
  type        = string
  description = "ARN of an ECS cluster."
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running."
  default     = 3
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the Load Balancer target group to associate with the service."
  default     = null
}

variable "container_name" {
  type        = string
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)."
  default     = null
}

variable "container_port" {
  type        = number
  description = "The port on the container to associate with the load balancer."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}
