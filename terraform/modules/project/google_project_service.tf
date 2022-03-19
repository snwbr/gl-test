resource "google_project_service" "project" {
  count   = length(var.apis)
  project = var.project
  service = var.apis[count.index]

  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = true
  lifecycle {
    prevent_destroy = true
  }
}