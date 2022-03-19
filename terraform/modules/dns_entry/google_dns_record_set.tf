resource "google_dns_record_set" "dns_entry" {
  count   = length(var.data)
  project = var.project
  name    = var.data[count.index]["dns_entry"]
  type    = var.data[count.index]["type"]
  ttl     = lookup(var.data[count.index], "ttl", var.default_ttl)

  managed_zone = var.zone
  rrdatas      = var.data[count.index]["data"]
}
