# Shared vars start
# =================
variable "region" {
  description = "GCP region used for project deployment."
  type        = string
}

variable "project_id" {
  description = "GCP project ID to use."
  type        = string
}
# Shared vars end
# ===============

# GKE config vars start
# =====================
variable "name" {
  description = "The name of the cluster."
  type        = string
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)."
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The VPC network to host the cluster in."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in."
  type        = string
}

variable "ip_range_pods" {
  description = "The _name_ of the secondary subnet ip range to use for pods."
  type        = string
}

variable "ip_range_services" {
  description = "The _name_ of the secondary subnet range to use for services."
  type        = string
}
# GKE config vars end
# ===================
