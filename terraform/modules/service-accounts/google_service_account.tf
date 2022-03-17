resource "google_service_account" "sa" {
  count        = var.create ? 1 : 0
  project      = var.project
  description  = var.description
  account_id   = var.name
  display_name = "${var.name} - Service Account"
}

resource "google_project_iam_member" "sa_roles" {
  count   = var.create ? length(var.sa_roles_list) : 0
  member  = "serviceAccount:${google_service_account.sa.*.email[floor(count.index / length(var.sa_roles_list))]}"
  project = var.project
  role    = var.sa_roles_list[count.index % length(var.sa_roles_list)]
}

resource "google_service_account_iam_binding" "sa-account-iam" {
  count              = var.create ? length(var.service_account_users) : 0
  service_account_id = google_service_account.sa.*.name[count.index]
  role               = "roles/iam.serviceAccountUser"
  members            = var.service_account_users
}
