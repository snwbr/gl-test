module "sa-gke" {
  source  = "../../modules/service-accounts"
  create  = var.sa_gke_create
  project = var.project
  name    = "sa-gke"
  sa_roles_list = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ]

  description = "${upper(var.env)} - GKE Service Account"
}
