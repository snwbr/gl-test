resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "managed-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary[0].name
  node_count = 1
  version    = var.gke_version

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = var.oauth_scopes
    tags            = var.gke_tags
    service_account = var.gke_service_account
  }

  autoscaling {
    min_node_count = 1
    max_node_count = var.node_pool_max_node_count
  }

  management {
    auto_repair = true
  }
}
