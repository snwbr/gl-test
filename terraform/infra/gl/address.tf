module "address" {
  source       = "terraform-google-modules/address/google"
  version      = "3.1.1"
  project_id   = var.project
  region       = "us-central1"
  address_type = "EXTERNAL"
  names = [
    "traefik-lb",
  ]
  addresses = var.reserved_addresses
}