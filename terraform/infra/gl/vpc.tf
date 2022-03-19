module "vpc" {
  source  = "../../modules/network/vpc"
  project = var.project
  name    = "${var.env}-vpc-network"
}

module "gke_subnetwork" {
  source             = "../../modules/network/subnet"
  project            = var.project
  region             = var.region
  name               = "${module.vpc.vpc_name}-${replace(replace(var.gke_cidr_range, ".", "-"), "/", "-")}-subnet"
  ip_cidr_range      = var.gke_cidr_range
  vpc_network        = module.vpc.vpc_id
  secondary_ip_range = var.gke_secondary_ip_range
}
