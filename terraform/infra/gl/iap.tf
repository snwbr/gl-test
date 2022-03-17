locals {
  whitelisted_ranges = ["35.235.240.0/20"]
}

// Creating this rule to allow IAP TCP forwarding, basically to use SSH through IAP to connect to nodes with private IP.
// This range specified in 'local.whitelisted_ranges' contains all IP addresses that IAP uses for TCP forwarding.
// https://cloud.google.com/iap/docs/using-tcp-forwarding
resource "google_compute_firewall" "gke_ssh_rules" {
  project = var.project
  name    = "gke-allow-ssh"
  network = module.vpc.vpc_name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = local.whitelisted_ranges
}
