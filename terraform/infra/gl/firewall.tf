
resource "google_compute_firewall" "gke_traefik_rules" {
  project = var.project
  name    = "gke-allow-traefik-dashboard"
  network = module.vpc.vpc_name
  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
  source_ranges = ["90.162.36.178/32"]
}


