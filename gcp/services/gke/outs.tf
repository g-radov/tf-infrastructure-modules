# GKE config outs start
# =====================
output "endpoint" {
  description = "Cluster endpoint"
  value       = module.this.endpoint
}

output "name" {
  description = "Cluster name"
  value       = module.this.name
}
# GKE config outs end
# ===================
