variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer"
  type        = list(string)
  default     = null
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

