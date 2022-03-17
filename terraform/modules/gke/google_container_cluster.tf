resource "google_container_cluster" "primary" {
  count              = var.create ? 1 : 0
  name               = var.cluster
  description        = "Terraform-managed Kubernetes Cluster"
  location           = var.region
  project            = var.project
  min_master_version = var.gke_version

  network    = var.vpc_network
  subnetwork = var.subnetwork_vpc_name

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
  }

  # Enable ip alias
  ip_allocation_policy {
    // needs existing range names assigned to the project
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  master_authorized_networks_config {
  }

}
