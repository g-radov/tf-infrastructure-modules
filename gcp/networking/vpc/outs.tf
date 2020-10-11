# VPC config outputs start
# ========================
output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.vpc.subnets_names
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets"
  value       = module.vpc.subnets_secondary_ranges
}
# VPC config outputs end
# ======================
