module "this" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "11.1.0"
  project_id                 = var.project_id
  name                       = var.name
  region                     = var.region
  zones                      = var.zones
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  remove_default_node_pool   = true
  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      min_count          = 1
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]
  node_pools_oauth_scopes = {
    all = []
    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  node_pools_labels = {
    all = {}
    default-node-pool = {
      default-node-pool = true
    }
  }
  node_pools_metadata = {
    all = {}
    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }
  node_pools_tags = {
    all = []
    default-node-pool = [
      "default-node-pool",
    ]
  }
}
