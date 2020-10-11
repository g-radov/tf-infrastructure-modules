# modules used:
# =============
# - https://registry.terraform.io/modules/terraform-google-modules/network/google/latest

# VPC config start
# ================
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode
  subnets = [
    {
      subnet_name   = "${var.network_name}-subnet-a"
      subnet_ip     = var.subnet_ip.0
      subnet_region = var.region
      description   = var.subnet_description
    },
  ]
  secondary_ranges = {
    "${var.network_name}-subnet-a" = [
      {
        range_name    = "${var.network_name}-subnet-a-secondary"
        ip_cidr_range = "192.168.0.0/16"
      },
    ]
  }
  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}
# VPC config end
# ==============
