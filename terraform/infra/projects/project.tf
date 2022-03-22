module "gcp_project_service_usage" {
  source  = "../../modules/project"
  project = var.project
  apis = [
    "serviceusage.googleapis.com"
  ]
}

resource "time_sleep" "wait_10_mins" {
  depends_on      = [module.gcp_project_service_usage]
  create_duration = "10m"
}

module "gcp_project" {
  source  = "../../modules/project"
  project = var.project
  apis = [
    "autoscaling.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerfilesystem.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    #"logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "domains.googleapis.com",
    "dns.googleapis.com",
    "containerregistry.googleapis.com",
  ]
  depends_on = [
    time_sleep.wait_10_mins
  ]
}
