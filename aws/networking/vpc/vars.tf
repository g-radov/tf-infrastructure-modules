# module.this variables start
# ===========================
variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden."
  type        = string
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region."
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
# module.this variables end
# =========================
