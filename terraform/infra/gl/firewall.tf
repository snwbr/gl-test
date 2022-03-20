
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

resource "google_compute_firewall" "gke_kubeseal_rules" {
  project = var.project
  name    = "gke-to-kubeseal-8080"
  network = module.vpc.vpc_name
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges           = [var.gke_master_ipv4_cidr_block]
  target_service_accounts = [module.sa-gke.service_account_emails[0]]
}
