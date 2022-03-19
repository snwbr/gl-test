module "gke_nat" {
  source      = "../../modules/network/nat"
  project     = var.project
  region      = var.region
  name        = "gke-nat"
  vpc_network = module.vpc.vpc_id
}
