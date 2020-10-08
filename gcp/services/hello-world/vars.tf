variable "project_id" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "network" {
  type    = string
  default = ""
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "ip_range_pods" {
  type    = string
  default = ""
}

variable "ip_range_services" {
  type    = string
  default = ""
}
