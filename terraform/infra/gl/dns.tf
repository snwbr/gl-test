resource "google_dns_managed_zone" "snwbr-net" {
  name        = var.zone_name
  dns_name    = var.domain
  description = "DNS zone for domain: ${var.domain}. Managed by Terraform"
  labels      = var.dns_labels
  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "on"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

module "snwbr_net_records" {
  source  = "../../modules/dns_entry"
  project = var.project
  zone    = google_dns_managed_zone.snwbr-net.name
  data    = var.snwbr_net_records
}
