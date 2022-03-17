output "cluster" {
  value = google_container_cluster.primary[0].name
}

output "host" {
  value     = google_container_cluster.primary[0].endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.primary[0].master_auth.0.cluster_ca_certificate
  sensitive = true
}

output "client_certificate" {
  value     = google_container_cluster.primary[0].master_auth[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = google_container_cluster.primary[0].master_auth[0].client_key
  sensitive = true
}

output "endpoint" {
  value = google_container_cluster.primary[0].endpoint
}

