# Shared vars start
# =================
variable "region" {
  description = "GCP region used for project deployment."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "GCP project ID to use."
  type        = string
}
# Shared vars end
# ===============

# VPC config vars start
# =====================
variable "network_name" {
  description = "The name of the network being created."
  type        = string
}

variable "routing_mode" {
  description = "The network routing mode."
  type        = string
  default     = "GLOBAL"
}

variable "subnet_ip" {
  description = "VPC subnet IP ranges"
  type        = list(string)
  default     = []
}

variable "subnet_description" {
  type    = string
  default = <<EOF
  "An optional description of subnet.
  The resource must be recreated to modify this field."
  EOF
}
# VPC config vars end
# ===================
