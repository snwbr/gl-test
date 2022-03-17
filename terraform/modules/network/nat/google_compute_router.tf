resource "google_compute_router" "router" {
  project = var.project
  name    = "${var.name}-router"
  network = var.vpc_network
  region  = var.region
}
