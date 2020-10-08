variable "region" {
  type    = string
  default = ""
}

variable "project_id" {
  type    = string
  default = ""
}

variable "network_name" {
  type    = string
  default = ""
}

variable "routing_mode" {
  type    = string
  default = ""
}

variable "subnet_ip" {
  type    = list(string)
  default = []
}

variable "subnet_description" {
  type    = string
  default = ""
}
