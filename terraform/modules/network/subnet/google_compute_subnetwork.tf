resource "google_compute_subnetwork" "subnet" {
  project                  = var.project
  name                     = var.name
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = var.vpc_network
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = length(var.secondary_ip_range) > 0 ? toset(var.secondary_ip_range) : toset({})
    content {
      range_name    = secondary_ip_range.value["secondary_ip_range_name"]
      ip_cidr_range = secondary_ip_range.value["secondary_ip_range_cidr"]
    }
  }
}
