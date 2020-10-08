output "network_name" {
  value = module.vpc.network_name
}

output "subnets_names" {
  value = module.vpc.subnets_names
}

output "subnets_secondary_ranges" {
  value = module.vpc.subnets_secondary_ranges
}
