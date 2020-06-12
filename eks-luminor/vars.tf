variable "environment" {
  description = "Project environment"
  type        = string
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable "enable_nat_gateway" {
  description = <<EOF
  "Should be true if you want to provision NAT Gateways
  for each of your private networks"
  EOF
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = <<EOF
  "Should be true if you want to create a new VPN Gateway
  resource and attach it to the VPC"
  EOF
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.16"
}

variable "wg_instance_type" {
  description = "The type of instance to use for worker nodes"
  type        = string
  default     = "t3a.small"
}

variable "wg_asg_max_size" {
  description = "The maximum size of the worker nodes auto scale group"
  type        = number
  default     = 2
}
